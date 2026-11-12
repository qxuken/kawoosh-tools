return {
  servers = {
    {
      order = 60,
      name = "bash",
      args = { "start" },
      cmd = "bash-language-server",
      install = {
        npm = "bash-language-server",
      },
    },
  },
  formatters = {
    {
      order = 70,
      name = "shfmt",
      args = { "--filename", "{path}" },
      cmd = "shfmt",
      install = {
        go = "mvdan.cc/sh/v3/cmd/shfmt",
      },
      languages = { "bash" },
      probe = {
        bash = "if a; then\nb\nfi\n",
      },
      when = "never",
    },
  },
}
