return {
  servers = {
    {
      order = 410,
      name = "r",
      args = { "--no-echo", "-e", "languageserver::run()" },
      cmd = "R",
      install = "R -e \"install.packages('languageserver', repos = 'https://cloud.r-project.org')\"",
      roots = { "DESCRIPTION", ".Rprofile" },
    },
  },
}
