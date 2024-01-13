{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.rose-pine = {
    url = "github:rose-pine/neovim";
    flake = false;
  };
  inputs.nil = {
    url = "github:oxalica/nil";
  };
  outputs = { self, nixpkgs, rose-pine, nil, ...}:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};       
    in {
      nixosModules."home-manager" = ( import ./modules/home-manager.nix { 
        inherit rose-pine;
	nil = nil.packages.${system}.default;
	custom-plugin-src = ./src; 
      } );
    };
}
