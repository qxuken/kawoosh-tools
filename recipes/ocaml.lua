return {
  servers = {
    {
      order = 300,
      name = "ocaml",
      cmd = "ocamllsp",
      install = "opam install ocaml-lsp-server",
      roots = { "dune-project", "dune-workspace" },
    },
  },
}
