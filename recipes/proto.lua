return {
  servers = {
    {
      order = 430,
      name = "proto",
      cmd = "protols",
      install = {
        cargo = "protols",
      },
      roots = { "protols.toml", "buf.yaml" },
    },
  },
}
