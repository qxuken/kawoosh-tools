return {
  servers = {
    {
      order = 360,
      name = "clojure",
      cmd = "clojure-lsp",
      install = {
        linux = "brew install clojure-lsp/brew/clojure-lsp-native",
        mac = "brew install clojure-lsp/brew/clojure-lsp-native",
      },
      roots = { "deps.edn", "project.clj", "bb.edn", "shadow-cljs.edn" },
    },
  },
}
