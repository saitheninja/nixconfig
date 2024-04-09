
{ config, pkgs, lib, ... }:

{
  options = {
    configNixvim.enable = lib.mkEnableOption "Adds Neovim configured with nixvim.";
  };

  config = lib.mkIf config.configNixvim.enable {
    inputs.nixvim.nixosModules.nixvim.options = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
    };

    plugins.lightline.enable = true;

    colorschemes.gruvbox.enable = true;

    plugins = {
      lsp = {
        enable = true;
        servers = {
          tsserver.enable = true;
          lua-ls.enable = true;
        };
      };

      telescope.enable = true;
      treesitter.enable = true;
    };
  };
}
