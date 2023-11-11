{ rose-pine }:
{ config, pkgs, ...}:
let
  cfg = config.programs.mrr-neovim;
  vimPlugins = pkgs.vimPlugins.extend (final': prev': {
    rose-pine = pkgs.vimUtils.buildVimPlugin {
      name = "rose-pine";
      src = rose-pine;
    };
    mrr-config = pkgs.vimUtils.buildVimPlugin {
    name = "mrr-config";
    src = ./src;
    };
  });
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
    enable = mkEnableOption "neovim with mrr config";
  };
  config = mkIf cfg.enable {
    programs.neovim = custom-neovim;
  };
}
