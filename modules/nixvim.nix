{ config, pkgs, lib, ... }:

{
  # imports = [ nixvim.nixosModules.nixvim ];

  options = {
    configNixvim.enable = lib.mkEnableOption "Adds Neovim, configured with nixvim.";
  };

  config = lib.mkIf config.configNixvim.enable {
    programs.nixvim = {
      enable = true;

      globals.mapleader = " ";

      opts = {
        number = true;
        relativenumber = true;

        shiftwidth = 2;
      };


      colorschemes.gruvbox.enable = true;

      plugins.lsp = {
	      enable = true;
	      servers = {
		      tsserver.enable = true;
		      lua-ls.enable = true;
	      };
      };

    # plugins = {
    #   lightline.enable = true;
    #   telescope.enable = true;
    #   treesitter.enable = true;
    # };
    };
  };
}
