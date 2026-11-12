return {
  servers = {
    {
      order = 500,
      name = "teal",
      cmd = "teal-language-server",
      install = "luarocks install teal-language-server",
      roots = { "tlconfig.lua" },
    },
  },
}
