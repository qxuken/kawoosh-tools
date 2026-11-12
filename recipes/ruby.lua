return {
  servers = {
    {
      order = 210,
      name = "ruby",
      cmd = "ruby-lsp",
      install = "gem install ruby-lsp",
      roots = { "Gemfile", ".ruby-version" },
    },
  },
}
