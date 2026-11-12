return {
  servers = {
    {
      order = 200,
      name = "php",
      args = { "--stdio" },
      cmd = "intelephense",
      install = {
        npm = "intelephense",
      },
      roots = { "composer.json" },
    },
  },
}
