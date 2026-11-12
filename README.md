# Kawoosh language tools

The independently released catalog of language-server and formatter recipes.
Kawoosh owns installation, execution, settings overrides and installed-version
records. This repository owns which packages, commands and defaults it knows.

Edit the Lua tables in `recipes/<language-or-tool>.lua`. A file returns a
table containing `servers`, `formatters`, or both; the recipe fields follow
Kawoosh's settings shape. Related tools share a file, such as
[Rust and rustfmt](recipes/rust.lua), [both TypeScript servers](recipes/typescript.lua),
and [biome's server and formatter](recipes/biome.lua). The extracted VS Code
servers share [one package file](recipes/vscode-langservers.lua).

Each row has a stable `name`, executable `cmd`, and an authoring-only `order`.
Order is unique within each kind and preserves the sequence in which Kawoosh
considers servers; file names never determine precedence. Existing orders
have gaps for future additions. The runner strips `order` from the output.
Arguments, languages, roots and dependencies use ordinary Lua lists. Install
is a command string, a `{ mac = ..., linux = ..., windows = ... }` table, or
one manager (`npm`, `pip`, `cargo`, `go`, `dotnet`) with a package or package
list and optional `args`.

There is no interpolation in the runner: `{path}`, `{typescript}` and
`{package:vue}` stay literal strings for Kawoosh to resolve. Lua definitions
load only during verification/release builds, in an environment containing
the `array` helper. Inside arbitrary `settings`, `init` and `answers` JSON,
`{}` means an empty object and `array {}` an empty array. Known list fields
such as `args = {}` already become arrays. The application receives JSON;
it never executes the catalog's Lua source.

With Nushell 0.116.x and Lua 5.4 or newer on PATH:

```sh
nu scripts/verify.nu recipes/typescript.lua  # focus on one file
nu scripts/verify.nu                        # all files and global checks
nu scripts/test.nu                          # parity and regression checks
nu scripts/test.nu --r1-parity              # one-time r1 migration audit
nu scripts/build.nu --release r2            # dist/manifest.json
```

Set `KAWOOSH_TOOLS_LUA` to a Lua executable path if its name is not `lua`.
Nushell discovers files and handles the artifact; the dependency-free
[Lua runner](scripts/catalog.lua) loads, validates and serializes them.
Unknown fields, malformed installs/formatter probes, invalid JSON values,
duplicate names/orders and missing/cyclic server dependencies fail with the
source file, recipe and field. Focused checks cover that file's schema and
duplicates; run the full check for references across files. These checks
validate recipes without installing packages or executing their commands.
Changes to a tool's invocation should also record a targeted smoke test.

`dist/manifest.json` is generated and ignored. It contains schema 1, the
`--release` value, and ordered `servers`/`formatters` lists. There is no
checked-in generated manifest to edit. Tests exercise failed builds without
replacing existing output, compare repeated artifact bytes and builds after
a source-file rename, and check invocation from another directory. The
optional `--r1-parity` migration audit proves all 65 original r1 recipes and
their order are unchanged using a canonical content hash. Leave that
historical hash intact when deliberately changing recipes in later releases.

Publishing a new tag such as `r2` runs CI verification and builds with
`--release "$GITHUB_REF_NAME"`, then publishes the generated file under the
same `manifest.json` asset name. Existing release assets, including r1,
stay immutable. An installed tool is not upgraded by changing this catalog.
Kawoosh carries a pinned snapshot for offline use and can explicitly refresh
the cached catalog without reinstalling the application.

Consumers update and verify their bundled snapshot with Kawoosh's Nushell
catalog scripts. A catalog release does not automatically change a Kawoosh
source checkout or upgrade a user's installed packages.
