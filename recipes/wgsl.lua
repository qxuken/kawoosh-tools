return {
  servers = {
    {
      order = 460,
      name = "wgsl",
      cmd = "wgsl-analyzer",
      install = {
        args = { "--git", "https://github.com/wgsl-analyzer/wgsl-analyzer" },
        cargo = "wgsl-analyzer",
      },
    },
  },
}
