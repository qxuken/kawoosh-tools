return {
  servers = {
    {
      order = 290,
      name = "haskell",
      args = { "--lsp" },
      cmd = "haskell-language-server-wrapper",
      install = "ghcup install hls",
      roots = { "hie.yaml", "stack.yaml", "cabal.project", "package.yaml" },
    },
  },
}
