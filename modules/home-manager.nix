{ rose-pine, custom-plugin-src, nixd }:
{ config, pkgs, lib, ...}:
let
  cfg = config.programs.mrr-neovim;
  vimPlugins = pkgs.vimPlugins.extend (final': prev': {
    rose-pine = pkgs.vimUtils.buildVimPlugin {
      name = "rose-pine";
      src = rose-pine;
    };
    mrr-config = pkgs.vimUtils.buildVimPlugin {
    name = "mrr-config";
    src = custom-plugin-src;
    };
  });
  lsps = [
    pkgs.lua-language-server
    pkgs.haskellPackages.haskell-language-server
    nixd
    pkgs.elixirls
  ];
  custom-neovim = {
    enable = cfg.enable;
    extraLuaConfig = ''
      require("mrr");
    '';
    plugins = [
      vimPlugins.telescope-nvim
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-cmp
      vimPlugins.rose-pine
      vimPlugins.nvim-treesitter
      vimPlugins.mrr-config
      vimPlugins.vim-tmux-navigator
      (vimPlugins.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
    ];
  };
in
{
  options.programs.mrr-neovim = {
    enable = lib.mkEnableOption "neovim with mrr config";
    include_lsps = lib.mkOption {
      type = lib.types.bool;
    };
  };
  config = lib.mkMerge [
    ( lib.mkIf cfg.enable {
      programs.neovim = custom-neovim;
    } )
    ( lib.mkIf cfg.include_lsps {
      home.packages = lsps;
    } )
  ];
}
