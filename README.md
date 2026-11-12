# Kawoosh language tools

The independently released catalog of language-server and formatter recipes.
Kawoosh owns installation, execution, settings overrides and installed-version
records. This repository owns which packages, commands and defaults it knows.

`manifest.json` contains schema version 1, a release name, and the `servers`
and `formatters` lists. Recipes contain data only; each has a stable `name`
and `cmd`. Optional arguments, languages, workspace markers, install recipes,
initialization data and formatter probes follow Kawoosh's settings format.
An installed tool is not upgraded by changing this catalog.

Run `nu scripts/verify.nu` before committing. Set `release` to the tag being
published, then create a tag such as `r1`. The release workflow validates that
the tag matches the manifest and publishes `manifest.json` as its asset.
Kawoosh carries a pinned snapshot for offline use and can explicitly refresh
the cached catalog without reinstalling the application.

Consumers update and verify their bundled snapshot with Kawoosh's Nushell
catalog scripts. A catalog release does not automatically change a Kawoosh
source checkout or upgrade a user's installed packages.
