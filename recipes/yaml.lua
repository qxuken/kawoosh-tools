return {
  servers = {
    {
      order = 120,
      name = "yaml",
      args = { "--stdio" },
      cmd = "yaml-language-server",
      install = {
        npm = "yaml-language-server",
      },
    },
  },
}
