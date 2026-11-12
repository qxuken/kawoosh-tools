return {
  servers = {
    {
      order = 80,
      name = "nu",
      args = { "--lsp" },
      cmd = "nu",
      install = {
        linux = "cargo install nu --locked",
        mac = "brew install nushell",
        windows = "winget install nushell",
      },
    },
  },
}
