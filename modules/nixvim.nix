{ config, pkgs, lib, ... }:

{
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


      colorschemes = {
        # gruvbox.enable = true;

	catppuccin = {
	  enable = true;
	  flavour = "latte"; # latte, mocha, frappe, macchiato
	  transparentBackground = true;
	};
      };

      plugins.lsp = {
	enable = true;
	servers = {
	  lua-ls.enable = true;
	  nixd.enable = true;
	  svelte.enable = true;
	  tsserver.enable = true;
	};
      };

      plugins = {
        comment.enable = true;
        #emmet.enable = true;
      #   lightline.enable = true;
      #   telescope.enable = true;
      #   treesitter.enable = true;
      };
    };
  };
}
