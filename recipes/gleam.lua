return {
  servers = {
    {
      order = 330,
      name = "gleam",
      args = { "lsp" },
      cmd = "gleam",
      install = {
        linux = "brew install gleam",
        mac = "brew install gleam",
      },
      roots = { "gleam.toml" },
    },
  },
}
