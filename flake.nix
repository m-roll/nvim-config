{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.rose-pine = {
    url = "github:rose-pine/neovim";
    flake = false;
  };
  outputs = { self, nixpkgs, rose-pine, ...}:
    let 
      system = "x86_64-linux";
      vimPluginsOverlay = final: prev: {
        vimPlugins = prev.vimPlugins.extend (final': prev': {
          rose-pine = prev.vimUtils.buildVimPlugin {
            name = "rose-pine";
            src = rose-pine;
          };
          nvim-treesitter = (prev'.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars));
          mrr-config = prev.vimUtils.buildVimPlugin {
            name = "mrr-config";
            src = "./";
          };
        });
        neovim = prev.neovim // {
          plugins = [
            final.vimPlugins.telescope-nvim
            final.vimPlugins.nvim-lspconfig
            final.vimPlugins.nvim-cmp
            final.vimPlugins.rose-pine
            final.vimPlugins.nvim-treesitter
            final.vimPlugins.mrr-config
          ];
        };
      };
    in {
      overlays.${system}.default = vimPluginsOverlay
    };
}
