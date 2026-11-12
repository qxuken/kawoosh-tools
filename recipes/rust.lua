return {
  servers = {
    {
      order = 0,
      name = "rust",
      cmd = "rust-analyzer",
      install = "rustup component add rust-analyzer",
      roots = { "Cargo.toml" },
    },
  },
  formatters = {
    {
      order = 60,
      name = "rustfmt",
      args = { "--edition", "2021" },
      cmd = "rustfmt",
      install = "rustup component add rustfmt",
      languages = { "rust" },
      probe = {
        rust = "fn f() {\nlet a = 1;\n}\n",
      },
      when = "never",
    },
  },
}
