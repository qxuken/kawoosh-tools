return {
  servers = {
    {
      order = 340,
      name = "elm",
      cmd = "elm-language-server",
      install = {
        npm = "@elm-tooling/elm-language-server",
      },
      roots = { "elm.json" },
    },
  },
}
