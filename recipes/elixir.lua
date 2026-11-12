return {
  servers = {
    {
      order = 310,
      name = "elixir",
      cmd = "elixir-ls",
      install = {
        linux = "brew install elixir-ls",
        mac = "brew install elixir-ls",
      },
      roots = { "mix.exs" },
    },
  },
}
