{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.rose-pine = {
    url = "github:rose-pine/neovim";
    flake = false;
  };
  inputs.nixd.url = github:nix-community/nixd;
  outputs = { self, nixpkgs, rose-pine, nixd, ...}:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};       
    in {
      nixosModules."home-manager" = ( import ./modules/home-manager.nix { 
        inherit rose-pine;
	nixd = nixd.packages.${system};
	custom-plugin-src = ./src; 
      } );
    };
}
