return {
  servers = {
    {
      order = 480,
      name = "odin",
      cmd = "ols",
      install = {
        linux = "brew install ols",
        mac = "brew install ols",
      },
      roots = { "ols.json", "odinfmt.json" },
    },
  },
}
