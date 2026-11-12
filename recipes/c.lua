return {
  servers = {
    {
      order = 50,
      name = "c",
      cmd = "clangd",
      install = {
        linux = "brew install llvm",
        mac = "xcode-select --install",
        windows = "winget install LLVM.LLVM",
      },
      languages = { "c", "cpp", "objc" },
      roots = { "compile_commands.json", ".clangd", "CMakeLists.txt", "Makefile" },
    },
  },
  formatters = {
    {
      order = 10,
      name = "clang-format",
      args = { "--assume-filename={path}" },
      cmd = "clang-format",
      install = {
        pip = "clang-format",
      },
      languages = { "c", "cpp" },
      probe = {
        c = "int f() {\nint a = 1;\nreturn a;\n}\n",
        cpp = "int f() {\nint a = 1;\nreturn a;\n}\n",
      },
      range = { "--offset={start}", "--length={length}" },
      when = { ".clang-format", "_clang-format" },
    },
  },
}
