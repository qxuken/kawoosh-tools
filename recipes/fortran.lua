return {
  servers = {
    {
      order = 400,
      name = "fortran",
      cmd = "fortls",
      install = {
        pip = "fortls",
      },
      roots = { ".fortls" },
    },
  },
}
