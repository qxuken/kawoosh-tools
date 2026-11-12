return {
  servers = {
    {
      order = 230,
      name = "kotlin",
      cmd = "kotlin-language-server",
      install = {
        linux = "brew install kotlin-language-server",
        mac = "brew install kotlin-language-server",
      },
      roots = { "settings.gradle.kts", "settings.gradle", "build.gradle.kts", "build.gradle", "pom.xml" },
    },
  },
}
