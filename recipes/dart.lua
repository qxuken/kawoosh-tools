return {
  servers = {
    {
      order = 270,
      name = "dart",
      args = { "language-server", "--protocol=lsp" },
      cmd = "dart",
      install = {
        linux = "brew install dart-lang/dart/dart",
        mac = "brew install dart-lang/dart/dart",
      },
      roots = { "pubspec.yaml" },
    },
  },
}
