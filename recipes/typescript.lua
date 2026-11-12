return {
  servers = {
    {
      order = 10,
      name = "typescript",
      args = { "--stdio" },
      cmd = "typescript-language-server",
      init = {
        plugins = {
          {
            languages = { "vue" },
            location = "{package:vue}",
            name = "@vue/typescript-plugin",
          },
        },
      },
      install = {
        npm = { "typescript-language-server", "typescript@5" },
      },
      languages = { "typescript", "tsx", "javascript" },
      roots = { "tsconfig.json", "jsconfig.json", "package.json" },
    },
    {
      order = 540,
      name = "typescript-native",
      languages = { "typescript", "tsx", "javascript" },
      cmd = "tsc",
      args = { "--lsp", "--stdio" },
      roots = { "tsconfig.json", "jsconfig.json", "package.json" },
      install = {
        npm = { "typescript@7.0.2" },
      },
    },
  },
}
