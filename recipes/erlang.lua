return {
  servers = {
    {
      order = 320,
      name = "erlang",
      cmd = "erlang_ls",
      install = {
        linux = "brew install erlang_ls",
        mac = "brew install erlang_ls",
      },
      roots = { "rebar.config", "erlang.mk" },
    },
  },
}
