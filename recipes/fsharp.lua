return {
  servers = {
    {
      order = 260,
      name = "fsharp",
      cmd = "fsautocomplete",
      install = {
        dotnet = "fsautocomplete",
      },
      roots = { "global.json", "Directory.Build.props" },
    },
  },
}
