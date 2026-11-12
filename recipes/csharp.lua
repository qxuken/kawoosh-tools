return {
  servers = {
    {
      order = 250,
      name = "csharp",
      cmd = "csharp-ls",
      install = {
        dotnet = "csharp-ls",
      },
      roots = { "global.json", "Directory.Build.props" },
    },
  },
}
