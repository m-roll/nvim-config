{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.rose-pine = {
    url = "github:rose-pine/neovim";
    flake = false;
  };
  inputs.nil = {
    url = "github:oxalica/nil";
  };
  inputs.conform = {
    url = "github:stevearc/conform.nvim";
    flake = false;
  };
  inputs.nickel.url = "github:tweag/nickel/stable";
  outputs =
    {
      nixpkgs,
      rose-pine,
      nil,
      conform,
      nickel,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosModules."home-manager" = (
        import ./modules/home-manager.nix {
          inherit rose-pine conform;
          nickel-lang-lsp = nickel.packages.${system}.nickel-lang-lsp;
          nil = nil.packages.${system}.default;
          custom-plugin-src = ./src;
        }
      );
      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
