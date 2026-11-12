return {
  servers = {
    {
      order = 180,
      name = "vue",
      args = { "--stdio", "--tsdk={typescript}" },
      cmd = "vue-language-server",
      install = {
        npm = { "@vue/language-server", "typescript@5" },
      },
      relay = {
        {
          command = "typescript.tsserverRequest",
          method = "tsserver/request",
          reply = "tsserver/response",
          to = "typescript",
        },
      },
      roots = { "package.json" },
      with = { "typescript" },
    },
  },
}
