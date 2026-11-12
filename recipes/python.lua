return {
  servers = {
    {
      order = 30,
      name = "python",
      args = { "--stdio" },
      cmd = "pyright-langserver",
      install = {
        npm = "pyright",
      },
      roots = { "pyproject.toml", "pyrightconfig.json", "setup.py", "requirements.txt" },
    },
  },
}
