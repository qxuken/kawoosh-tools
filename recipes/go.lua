return {
  servers = {
    {
      order = 40,
      name = "go",
      cmd = "gopls",
      install = {
        go = "golang.org/x/tools/gopls",
      },
      languages = { "go", "gomod" },
      roots = { "go.work", "go.mod" },
    },
  },
  formatters = {
    {
      order = 20,
      name = "gofmt",
      args = {  },
      cmd = "gofmt",
      languages = { "go" },
      when = "always",
    },
  },
}
