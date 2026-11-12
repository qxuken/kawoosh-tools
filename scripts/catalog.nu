# Nushell handles file discovery and process/output plumbing; Lua owns
# the definitions, schema and deterministic JSON serialization.
const ROOT = path self ..

export def run-catalog [source: path, release: string, recipe?: path] {
  let files = if $recipe == null {
    glob ($source | path join recipes '*.lua' | str replace --all '\' '/') | sort
  } else {
    let file = $recipe | path expand
    if ($file | path parse | get extension) != lua { error make {msg: $"($file): recipe must be a Lua file"} }
    [$file]
  }
  if ($files | is-empty) { error make {msg: $"($source): recipes: no Lua recipe files"} }
  let program = $env.KAWOOSH_TOOLS_LUA? | default lua
  let runner = $ROOT | path join scripts catalog.lua
  let arguments = $files | each {|file| ['--file' $file] } | flatten
  let focused = if $recipe == null { [] } else { ['--verify-file'] }
  let result = do { ^$program $runner --release $release ...$focused ...$arguments } | complete
  if $result.exit_code != 0 { error make {msg: ($result.stderr | str trim)} }
  {text: $result.stdout catalog: ($result.stdout | from json)}
}
