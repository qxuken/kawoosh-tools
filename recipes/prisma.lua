return {
  servers = {
    {
      order = 420,
      name = "prisma",
      args = { "--stdio" },
      cmd = "prisma-language-server",
      install = {
        npm = "@prisma/language-server",
      },
      roots = { "package.json" },
    },
  },
}
