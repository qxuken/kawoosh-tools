#!/usr/bin/env nu
use catalog.nu run-catalog
const ROOT = path self ..

# Validate every recipe before writing the release artifact.
def main [--release: string = dev, --source: path, --output: path] {
  let root = $source | default $ROOT
  let output = $output | default ($ROOT | path join dist manifest.json)
  let result = run-catalog $root $release
  let catalog = $result.catalog
  $result.text | save --raw --force $output
  print $"built ($release): ($catalog.servers | length) servers, ($catalog.formatters | length) formatters -> ($output)"
}
