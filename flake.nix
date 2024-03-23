{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.rose-pine = {
    url = "github:rose-pine/neovim";
    flake = false;
  };
  inputs.nil = { url = "github:oxalica/nil"; };
  inputs.conform = {
    url = "github:stevearc/conform.nvim";
    flake = false;
  };
  outputs = { self, nixpkgs, rose-pine, nil, conform, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosModules."home-manager" = (import ./modules/home-manager.nix {
        inherit rose-pine;
        inherit conform;
        nil = nil.packages.${system}.default;
        custom-plugin-src = ./src;
      });
    };
}
