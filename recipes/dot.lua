return {
  servers = {
    {
      order = 440,
      name = "dot",
      args = { "--stdio" },
      cmd = "dot-language-server",
      install = {
        npm = "dot-language-server",
      },
    },
  },
}
