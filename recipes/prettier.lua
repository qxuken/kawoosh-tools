return {
  formatters = {
    {
      order = 30,
      name = "prettier",
      args = { "--stdin-filepath", "{path}" },
      cmd = "prettier",
      install = {
        npm = "prettier",
      },
      languages = { "javascript", "typescript", "tsx", "json", "jsonc", "css", "yaml", "markdown" },
      node = true,
      probe = {
        css = "a {\nb: c;\n}\n",
        javascript = "if (a) {\nb;\n}\n",
        json = "{\n\"a\": 1\n}\n",
        jsonc = "{\n\"a\": 1\n}\n",
        tsx = "if (a) {\nb;\n}\n",
        typescript = "if (a) {\nb;\n}\n",
      },
      range = { "--range-start", "{start_utf16}", "--range-end", "{end_utf16}" },
      when = { ".prettierrc", ".prettierrc.json", ".prettierrc.json5", ".prettierrc.yaml", ".prettierrc.yml", ".prettierrc.toml", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs", ".prettierrc.ts", "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs", "prettier.config.ts", "package.json:prettier" },
    },
    {
      order = 40,
      name = "prettierd",
      args = { "{path}" },
      cmd = "prettierd",
      install = {
        npm = "@fsouza/prettierd",
      },
      languages = { "javascript", "typescript", "tsx", "json", "jsonc", "css", "yaml", "markdown" },
      node = true,
      probe = {
        css = "a {\nb: c;\n}\n",
        javascript = "if (a) {\nb;\n}\n",
        json = "{\n\"a\": 1\n}\n",
        jsonc = "{\n\"a\": 1\n}\n",
        tsx = "if (a) {\nb;\n}\n",
        typescript = "if (a) {\nb;\n}\n",
      },
      when = { ".prettierrc", ".prettierrc.json", ".prettierrc.json5", ".prettierrc.yaml", ".prettierrc.yml", ".prettierrc.toml", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs", ".prettierrc.ts", "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs", "prettier.config.ts", "package.json:prettier" },
    },
  },
}
