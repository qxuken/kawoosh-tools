return {
  servers = {
    {
      order = 20,
      name = "lua",
      cmd = "lua-language-server",
      install = {
        linux = "brew install lua-language-server",
        mac = "brew install lua-language-server",
      },
      roots = { ".luarc.json", ".luarc.jsonc" },
    },
  },
  formatters = {
    {
      order = 80,
      name = "stylua",
      args = { "--stdin-filepath", "{path}", "-" },
      cmd = "stylua",
      install = {
        args = { "--locked" },
        cargo = "stylua",
      },
      languages = { "lua" },
      probe = {
        lua = "if a then\nb()\nend\n",
      },
      range = { "--range-start", "{start}", "--range-end", "{end}" },
      when = { "stylua.toml", ".stylua.toml" },
    },
  },
}
