return {
  servers = {
    {
      order = 140,
      name = "markdown",
      args = { "server" },
      cmd = "marksman",
      install = {
        linux = "brew install marksman",
        mac = "brew install marksman",
      },
      roots = { ".marksman.toml" },
    },
  },
}
