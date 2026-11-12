return {
  servers = {
    {
      order = 390,
      name = "cmake",
      cmd = "cmake-language-server",
      install = {
        pip = { "cmake-language-server", "pygls<2" },
      },
      roots = { "CMakeLists.txt" },
    },
  },
}
