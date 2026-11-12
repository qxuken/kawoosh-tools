return {
  servers = {
    {
      order = 170,
      name = "astro",
      args = { "--stdio" },
      cmd = "astro-ls",
      init = {
        typescript = {
          tsdk = "{typescript}",
        },
      },
      install = {
        npm = { "@astrojs/language-server", "typescript@5" },
      },
      roots = { "astro.config.mjs", "astro.config.ts", "astro.config.js", "package.json" },
    },
  },
}
