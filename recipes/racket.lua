return {
  servers = {
    {
      order = 370,
      name = "racket",
      args = { "-l", "racket-langserver" },
      cmd = "racket",
      install = "raco pkg install --auto racket-langserver",
      roots = { "info.rkt" },
    },
  },
}
