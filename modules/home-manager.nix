{
  rose-pine,
  custom-plugin-src,
  nil,
  conform,
  nickel-lang-lsp,
  vim-nickel,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.mrr-neovim;
  vimPlugins = pkgs.vimPlugins.extend (
    final': prev': {
      rose-pine = pkgs.vimUtils.buildVimPlugin {
        name = "rose-pine";
        src = rose-pine;
      };
      mrr-config = pkgs.vimUtils.buildVimPlugin {
        name = "mrr-config";
        src = custom-plugin-src;
      };
      conform = pkgs.vimUtils.buildVimPlugin {
        name = "conform";
        src = conform;
      };
      vim-nickel = pkgs.vimUtils.buildVimPlugin {
        name = "vim-nickel";
        src = vim-nickel;
      };
    }
  );
  lsps = [
    pkgs.lua-language-server
    pkgs.haskellPackages.haskell-language-server
    nil
    pkgs.elixir-ls
    pkgs.nixfmt-rfc-style
    pkgs.stylua
    nickel-lang-lsp
  ];
  custom-neovim = {
    enable = cfg.enable;
    extraLuaConfig = ''
      NVIM_CONFIG_ELIXIR_LS_PATH = "${pkgs.elixir-ls}/lib/language_server.sh"
      require("mrr");
    '';
    plugins = [
      vimPlugins.telescope-nvim
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-cmp
      vimPlugins.diffview-nvim
      vimPlugins.rose-pine
      vimPlugins.conform
      vimPlugins.nvim-treesitter
      vimPlugins.mrr-config
      vimPlugins.vim-tmux-navigator
      vimPlugins.formatter-nvim
      vimPlugins.vim-nickel
      (vimPlugins.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
    ];
  };
in
{
  options.programs.mrr-neovim = {
    enable = lib.mkEnableOption "neovim with mrr config";
    include_lsps = lib.mkOption { type = lib.types.bool; };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable { programs.neovim = custom-neovim; })
    (lib.mkIf cfg.include_lsps { home.packages = lsps; })
  ];
}
