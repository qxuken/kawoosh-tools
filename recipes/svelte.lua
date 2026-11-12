return {
  servers = {
    {
      order = 160,
      name = "svelte",
      args = { "--stdio" },
      cmd = "svelteserver",
      install = {
        npm = "svelte-language-server",
      },
      roots = { "svelte.config.js", "package.json" },
    },
  },
}
