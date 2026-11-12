return {
  servers = {
    {
      order = 150,
      name = "dockerfile",
      args = { "--stdio" },
      cmd = "docker-langserver",
      install = {
        npm = "dockerfile-language-server-nodejs",
      },
    },
  },
}
