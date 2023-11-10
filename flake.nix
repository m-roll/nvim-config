{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.rose-pine = {
    url = "github:rose-pine/neovim";
    flake = false;
  };
  outputs = { self, nixpkgs, rose-pine, ...}:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
        vimPlugins = pkgs.vimPlugins.extend (final': prev': {
          rose-pine = pkgs.vimUtils.buildVimPlugin {
            name = "rose-pine";
            src = rose-pine;
          };
          nvim-treesitter = (final'.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars));
          mrr-config = pkgs.vimUtils.buildVimPlugin {
            name = "mrr-config";
            src = ./src;
          };
        });
	nvim_attrs = {
          # TODO: requiring feels unnecessary
          extraLuaConfig = ''
            require("mrr");
	    echo "hi";
          '';
          plugins = [
            vimPlugins.telescope-nvim
            vimPlugins.nvim-lspconfig
            vimPlugins.nvim-cmp
            vimPlugins.rose-pine
            vimPlugins.nvim-treesitter
            vimPlugins.mrr-config
            vimPlugins.vim-tmux-navigator
          ];
        };
    in {
      neovim-config.${system}.default = nvim_attrs;
    };
}
