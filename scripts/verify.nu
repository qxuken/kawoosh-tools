#!/usr/bin/env nu

use catalog.nu run-catalog
const ROOT = path self ..

# No executable in a recipe is installed or run during verification.
def main [recipe?: path, --release: string = dev, --source: path] {
  if $recipe != null {
    let catalog = (run-catalog ($source | default $ROOT) $release $recipe).catalog
    print $"verified ($recipe): (($catalog.servers | length) + ($catalog.formatters | length)) recipes; run verify.nu without a path for cross-file checks"
  } else {
    let catalog = (run-catalog ($source | default $ROOT) $release).catalog
    print $"verified ($release): ($catalog.servers | length) servers, ($catalog.formatters | length) formatters"
  }
}
