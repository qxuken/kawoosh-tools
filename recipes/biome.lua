return {
  servers = {
    {
      order = 520,
      name = "biome",
      args = { "lsp-proxy" },
      cmd = "biome",
      install = {
        npm = "@biomejs/biome",
      },
      languages = { "typescript", "tsx", "javascript", "json", "jsonc", "css" },
      roots = { "biome.json", "biome.jsonc" },
      when = { "biome.json", "biome.jsonc" },
    },
  },
  formatters = {
    {
      order = 0,
      name = "biome",
      args = { "format", "--stdin-file-path={path}" },
      cmd = "biome",
      install = {
        npm = "@biomejs/biome",
      },
      languages = { "javascript", "typescript", "tsx", "json", "jsonc", "css" },
      node = true,
      probe = {
        css = "a {\nb: c;\n}\n",
        javascript = "if (a) {\nb;\n}\n",
        json = "{\n\"a\": 1\n}\n",
        jsonc = "{\n\"a\": 1\n}\n",
        tsx = "if (a) {\nb;\n}\n",
        typescript = "if (a) {\nb;\n}\n",
      },
      when = { "biome.json", "biome.jsonc" },
    },
  },
}
