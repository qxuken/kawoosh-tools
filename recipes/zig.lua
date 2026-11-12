return {
  servers = {
    {
      order = 280,
      name = "zig",
      cmd = "zls",
      install = {
        linux = "brew install zls",
        mac = "brew install zls",
      },
      roots = { "build.zig", "build.zig.zon" },
    },
  },
}
