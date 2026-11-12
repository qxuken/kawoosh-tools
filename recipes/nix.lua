return {
  servers = {
    {
      order = 380,
      name = "nix",
      cmd = "nil",
      install = {
        linux = "nix profile install nixpkgs#nil",
        mac = "nix profile install nixpkgs#nil",
      },
      roots = { "flake.nix" },
    },
  },
}
