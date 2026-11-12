return {
  servers = {
    {
      order = 530,
      name = "ruff",
      args = { "server" },
      cmd = "ruff",
      install = {
        pip = "ruff",
      },
      languages = { "python" },
      roots = { "pyproject.toml", "ruff.toml", ".ruff.toml" },
      when = { "ruff.toml", ".ruff.toml" },
    },
  },
  formatters = {
    {
      order = 50,
      name = "ruff",
      args = { "format", "--stdin-filename", "{path}", "-" },
      cmd = "ruff",
      install = {
        pip = "ruff",
      },
      languages = { "python" },
      probe = {
        python = "if a:\n  b\n",
      },
      when = { "ruff.toml", ".ruff.toml", "pyproject.toml:tool.ruff" },
    },
  },
}
