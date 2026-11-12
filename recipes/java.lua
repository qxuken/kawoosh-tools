return {
  servers = {
    {
      order = 220,
      name = "java",
      cmd = "jdtls",
      install = {
        linux = "brew install jdtls",
        mac = "brew install jdtls",
      },
      roots = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts" },
    },
  },
}
