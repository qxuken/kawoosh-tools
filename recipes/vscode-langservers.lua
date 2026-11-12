return {
  servers = {
    {
      order = 90,
      name = "html",
      args = { "--stdio" },
      cmd = "vscode-html-language-server",
      install = {
        npm = "vscode-langservers-extracted",
      },
      roots = { "package.json" },
    },
    {
      order = 100,
      name = "css",
      args = { "--stdio" },
      cmd = "vscode-css-language-server",
      install = {
        npm = "vscode-langservers-extracted",
      },
      languages = { "css", "scss" },
      roots = { "package.json" },
    },
    {
      order = 110,
      name = "json",
      args = { "--stdio" },
      cmd = "vscode-json-language-server",
      install = {
        npm = "vscode-langservers-extracted",
      },
      languages = { "json", "jsonc" },
    },
    {
      order = 510,
      name = "eslint",
      answers = {
        ["eslint/confirmESLintExecution"] = 4,
      },
      args = { "--stdio" },
      cmd = "vscode-eslint-language-server",
      install = {
        npm = "vscode-langservers-extracted",
      },
      languages = { "typescript", "tsx", "javascript" },
      roots = { "package.json" },
      settings = {
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = "separateLine",
          },
          showDocumentation = {
            enable = true,
          },
        },
        codeActionOnSave = {
          enable = false,
          mode = "all",
        },
        experimental = {
          useFlatConfig = false,
        },
        format = false,
        nodePath = "",
        onIgnoredFiles = "off",
        problems = {
          shortenToSingleLine = false,
        },
        quiet = false,
        run = "onType",
        useESLintClass = false,
        validate = "on",
        workingDirectory = {
          mode = "location",
        },
        workspaceFolder = "root",
      },
      when = { "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts", "eslint.config.mts", "eslint.config.cts", ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml" },
    },
  },
}
