return {
  servers = {
    {
      order = 70,
      name = "fish",
      args = { "start" },
      cmd = "fish-lsp",
      install = {
        npm = "fish-lsp",
      },
    },
  },
}
