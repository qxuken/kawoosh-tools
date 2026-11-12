return {
  servers = {
    {
      order = 350,
      name = "purescript",
      args = { "--stdio" },
      cmd = "purescript-language-server",
      install = {
        npm = "purescript-language-server",
      },
      roots = { "spago.yaml", "spago.dhall" },
    },
  },
}
