#!/usr/bin/env nu

# Catalog recipes are data. No program listed in them is executed here.
def main [path: path = manifest.json, --release: string] {
  let catalog = open $path
  if $catalog.schema != 1 { error make { msg: "unsupported catalog schema" } }
  if ($catalog.release | str trim | is-empty) { error make { msg: "missing release" } }
  if $release != null and $release != $catalog.release { error make { msg: "release tag and manifest disagree" } }
  for kind in [servers formatters] {
    let rows = $catalog | get $kind
    if ($rows | is-empty) { error make { msg: $"empty ($kind) catalog" } }
    let names = $rows | get name
    if ($names | uniq | length) != ($names | length) { error make { msg: $"duplicate ($kind) name" } }
    for row in $rows {
      if not ($row.name =~ '^[a-zA-Z0-9_.-]+$') { error make { msg: $"invalid recipe name: ($row.name)" } }
      if ($row.cmd | str trim | is-empty) { error make { msg: $"missing command: ($row.name)" } }
      for field in [args languages roots with] {
        let value = $row | get -o $field
        if $value != null {
          if not (($value | describe) | str starts-with 'list') { error make { msg: $"($row.name).($field) must be a list" } }
          if not ($value | all {|v| ($v | describe) == string }) { error make { msg: $"($row.name).($field) must contain strings" } }
        }
      }
    }
  }
  print $"verified ($catalog.release): ($catalog.servers | length) servers, ($catalog.formatters | length) formatters"
}
