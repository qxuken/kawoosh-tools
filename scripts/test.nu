#!/usr/bin/env nu
use std/assert
use catalog.nu run-catalog
const ROOT = path self ..

# Fixture writer only. Real definitions are ordinary, hand-edited Lua files.
def definition [value: any] {
  let kind = $value | describe
  if ($kind | str starts-with record) {
    '{' + ($value | transpose key value | each {|e| $"[(definition $e.key)]=(definition $e.value)" } | str join ',') + '}'
  } else if ($kind | str starts-with list) or ($kind | str starts-with table) {
    '{' + ($value | each {|e| definition $e } | str join ',') + '}'
  } else { $value | to json --raw }
}

def build [source: path, output: path, release: string] {
  do { ^($nu.current-exe) --no-config-file --error-style plain ($ROOT | path join scripts build.nu) --source $source --output $output --release $release } | complete
}

def rejected [source: path, output: path, expected: string] {
  'previous artifact' | save --raw --force $output
  let answer = build $source $output r2
  assert ($answer.exit_code != 0) $"invalid recipe unexpectedly built: ($expected)"
  assert ($answer.stderr | str contains test.lua) $"missing source file diagnostic: ($answer.stderr)"
  assert ($answer.stderr | str contains $expected) $"missing field diagnostic ($expected): ($answer.stderr)"
  assert equal (open --raw $output) 'previous artifact' "failed validation replaced the previous artifact"
}

def main [--r1-parity] {
  let temp_root = $env.TEMP? | default $env.TMPDIR? | default /tmp | path expand
  let temp = mktemp --directory --tmpdir-path $temp_root 'kawoosh-tools-test-XXXXXX' | path expand
  # Check the absolute cleanup target before any recursive removal.
  assert equal ($temp | path dirname) $temp_root
  assert ($temp | path basename | str starts-with kawoosh-tools-test-)
  let output = $temp | path join output nested manifest.json
  try {
    let first = build $ROOT $output r1
    assert equal $first.exit_code 0 $first.stderr
    let original = open --raw $output
    let second = build $ROOT $output r1
    assert equal $second.exit_code 0 $second.stderr
    assert equal (open --raw $output) $original "repeated build changed bytes"
    let catalog = open $output
    if $r1_parity {
      assert equal ($catalog.servers | length) 55
      assert equal ($catalog.formatters | length) 10
      assert equal ($catalog | to json --raw | hash sha256) (open --raw ($ROOT | path join tests r1-catalog.sha256) | str trim) "r1 recipe values or semantic order changed"
    }
    assert equal ((run-catalog $ROOT r2).catalog.release) r2
    let files = glob ($ROOT | path join recipes '*.lua' | str replace --all '\' '/') | sort
    for file in $files {
      let focused = (run-catalog $ROOT dev $file).catalog
      assert ((($focused.servers | length) + ($focused.formatters | length)) > 0)
    }
    let reordered = $temp | path join reordered
    mkdir $reordered
    cp --recursive ($ROOT | path join recipes) ($reordered | path join recipes)
    mv ($reordered | path join recipes typescript.lua) ($reordered | path join recipes zzz-renamed.lua)
    assert equal ((run-catalog $reordered r1).catalog) $catalog "file rename changed recipe precedence"

    let source = $temp | path join invalid
    mkdir ($source | path join recipes)
    let recipe = $source | path join recipes test.lua
    let valid = {
      servers: [{order: 0 name: test cmd: 'must-not-execute' install: {npm: test}}]
      formatters: [{order: 0 name: fmt cmd: 'must-not-execute' languages: [text] probe: {text: "a\n  b\n"}}]
    }
    let cases = [
      {field: 'servers.test.args[1]' edit: {|d| $d | upsert servers.0.args [42] }}
      {field: 'servers.test.cmd' edit: {|d| $d | update servers.0.cmd ' ' }}
      {field: 'servers.test.order' edit: {|d| $d | update servers.0.order (-1) }}
      {field: 'servers.test.argz' edit: {|d| $d | upsert servers.0.argz [] }}
      {field: 'servers.test.when' edit: {|d| $d | upsert servers.0.when 'project.toml' }}
      {field: 'servers.test.install.gem' edit: {|d| $d | update servers.0.install {gem: test} }}
      {field: 'servers.test.install' edit: {|d| $d | update servers.0.install {npm: test pip: test} }}
      {field: 'servers.test.install.npm' edit: {|d| $d | update servers.0.install {npm: []} }}
      {field: 'servers.test.install.args[1]' edit: {|d| $d | update servers.0.install {npm: test args: [7]} }}
      {field: 'servers.test.install.windows' edit: {|d| $d | update servers.0.install {windows: 3} }}
      {field: 'servers.test.relay[1].reply' edit: {|d| $d | upsert servers.0.relay [{method: request to: test command: reply}] }}
      {field: 'servers.test.relay.to' edit: {|d| $d | upsert servers.0.relay [{method: request to: unknown command: command reply: reply}] }}
      {field: 'servers.test.with' edit: {|d| $d | upsert servers.0.with [unknown] }}
      {field: 'dependency cycle' edit: {|d| $d | upsert servers.0.with [test] }}
      {field: 'formatters.fmt.node' edit: {|d| $d | upsert formatters.0.node yes }}
      {field: 'formatters.fmt.probe' edit: {|d| $d | update formatters.0.probe 'snippet' }}
      {field: 'formatters.fmt.probe.text' edit: {|d| $d | update formatters.0.probe.text 2 }}
      {field: 'formatters.fmt.range[1]' edit: {|d| $d | upsert formatters.0.range [9] }}
      {field: 'formatters.fmt.timeout_ms' edit: {|d| $d | upsert formatters.0.timeout_ms 0 }}
      {field: 'formatters.fmt.when' edit: {|d| $d | upsert formatters.0.when false }}
      {field: 'formatters.fmt.run' edit: {|d| $d | upsert formatters.0.run lua }}
    ]
    for case in $cases {
      'return ' + (definition (do $case.edit $valid)) | save --raw --force $recipe
      rejected $source $output $case.field
    }
    'return ' + (definition $valid) | save --raw --force $recipe
    let other = $source | path join recipes other.lua
    'return ' + (definition {servers: [{order: 10 name: test cmd: 'must-not-execute'}]}) | save --raw --force $other
    rejected $source $output 'duplicate name'
    'return ' + (definition {servers: [{order: 0 name: another cmd: 'must-not-execute'}]}) | save --raw --force $other
    rejected $source $output 'duplicate order'
    rm $other
    let base = 'local data = ' + (definition $valid) + "\n"
    let raw_cases = [
      {field: 'servers.test.settings.bad' lua: 'data.servers[1].settings = {bad = 0/0}'}
      {field: 'servers.test.settings.bad' lua: 'data.servers[1].settings = {bad = function() end}'}
      {field: 'servers.test.settings.self' lua: 'local t = {}; t.self = t; data.servers[1].settings = t'}
      {field: 'servers.test.args' lua: 'data.servers[1].args = {[1]="one", [3]="three", [5]="five"}'}
      {field: 'NUL' lua: 'data.servers[1].args = {"\0"}'}
      {field: 'UTF-8' lua: 'data.servers[1].args = {"\255"}'}
    ]
    for case in $raw_cases {
      $base + $case.lua + "\nreturn data" | save --raw --force $recipe
      rejected $source $output $case.field
    }
    'return {servers =' | save --raw --force $recipe
    rejected $source $output 'Lua'
    'os.execute("must-not-execute"); return {}' | save --raw --force $recipe
    rejected $source $output 'Lua'
    # Real JSON round-trip for escaping and the empty array/object distinction.
    $base + 'data.servers[1].settings = {empty_array = array {}, empty_object = {}, message = "quote \" slash \\ newline \n tab \t control \1 café"}; return data' | save --raw --force $recipe
    let answer = build $source $output r2
    assert equal $answer.exit_code 0 $answer.stderr
    let settings = (open $output).servers.0.settings
    assert equal ($settings.empty_array | describe) 'list<any>'
    assert equal ($settings.empty_object | describe) 'record'
    assert equal $settings.message ("quote \" slash \\ newline \n tab \t control " + (char --integer 1) + ' café')
    let elsewhere = do {
      cd $temp
      ^($nu.current-exe) --no-config-file ($ROOT | path join scripts build.nu) --release r1 --output ($temp | path join elsewhere.json)
    } | complete
    assert equal $elsewhere.exit_code 0 $elsewhere.stderr
    assert equal (open --raw ($temp | path join elsewhere.json)) $original "default source depends on caller's cwd"
    let parity = if $r1_parity { 'r1 recipes/order preserved; ' } else { '' }
    print $"passed: ($parity)deterministic bytes, ($files | length) focused files, (($cases | length) + ($raw_cases | length) + 4) negative cases, JSON escaping, empty arrays/objects and caller cwd"
  } catch {|err|
    print --stderr $"test fixtures retained at ($temp)"
    error make {msg: $err.msg}
  }
  rm --recursive $temp
}
