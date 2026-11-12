return {
  servers = {
    {
      order = 130,
      name = "toml",
      args = { "lsp", "stdio" },
      cmd = "taplo",
      install = {
        args = { "--locked", "--features", "lsp" },
        cargo = "taplo-cli",
      },
      roots = { "taplo.toml", ".taplo.toml" },
    },
  },
  formatters = {
    {
      order = 90,
      name = "taplo",
      args = { "fmt", "-" },
      cmd = "taplo",
      install = {
        args = { "--locked", "--features", "lsp" },
        cargo = "taplo-cli",
      },
      languages = { "toml" },
      when = { ".taplo.toml", "taplo.toml" },
    },
  },
}
