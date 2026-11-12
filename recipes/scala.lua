return {
  servers = {
    {
      order = 240,
      name = "scala",
      cmd = "metals",
      install = "cs install metals",
      roots = { "build.sbt", "build.sc", "build.mill" },
    },
  },
}
