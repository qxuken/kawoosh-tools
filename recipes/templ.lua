return {
  servers = {
    {
      order = 190,
      name = "templ",
      args = { "lsp" },
      cmd = "templ",
      install = {
        go = "github.com/a-h/templ/cmd/templ",
      },
      roots = { "go.mod" },
    },
  },
}
