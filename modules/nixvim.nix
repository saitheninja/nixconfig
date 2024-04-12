{ config, pkgs, lib, ... }:

{
	options = {
		configNixvim.enable = lib.mkEnableOption "Adds Neovim, configured with nixvim.";
	};

	config = lib.mkIf config.configNixvim.enable {
		programs.nixvim = {
			enable = true;

			globals.mapleader = " ";

			clipboard.register = "unnamedplus"; # use system clipboard as default register

			opts = {
    		# line numbers
				number = true;
				relativenumber = true;

				# indents
				autoindent = true; # copy indent from current line when starting a new line
				smartindent = true; # do smart autoindenting when starting a new line
				expandtab = true; # expands tabs to spaces
				shiftwidth = 2; # number of spaces to use for each step of indent
				tabstop = 2; # number of spaces that a tab in a file counts for
				breakindent = true; # every wrapped line will continue visually indented

				# search
				ignorecase = true; # ignore case if all lowercase
				smartcase = true; # case-sensitive if mixed-case
        inccommand = "split"; # incremental preview for substitute

				# ui
				background = "dark"; # it tells Nvim what the "inherited" (terminal/GUI) background looks like
				cursorline = true; # highlight cursor line
        cursorlineopt = "number"; # line, number, both (line,number), screenline
        scrolloff = 999; # minimum number of rows to keep around the cursor
        sidescrolloff = 10; # minimum number of columns to keep around the cursor
				signcolumn = "yes"; # text shifts when it gets toggled
        # splitbelow = true;
        # splitright = true;
        termguicolors = true;
				visualbell = true;
        virtualedit = "block"; # the cursor can be positioned where there is no actual character (in visual block mode)
			};

			colorschemes = {
				gruvbox.enable = true;

				# catppuccin = {
				# 	enable = true;
				# 	flavour = "latte"; # latte, mocha, frappe, macchiato
				# 	transparentBackground = false;
				# };
			};

      plugins = {
        comment.enable = true;

        # completions
        cmp.enable = true;
        cmp-buffer.enable = true;
        cmp-cmdline.enable = true;
        cmp-cmdline-history.enable = true;
        cmp-emoji.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-nvim-lsp-signature-help.enable = true;
        cmp-nvim-lua.enable = true;
        cmp-path.enable = true;
        cmp-treesitter.enable = true;

        # debugger
        #dap.enable = true;

				#emmet.enable = true;
        #gitblame.enable = true;
        gitsigns.enable = true;
        indent-blankline.enable = true;

        # lsp
        lsp = {
          enable = true;
          servers = {
            emmet_ls.enable = true;
            eslint.enable = true;
            gdscript.enable = true;
            html.enable = true;
            jsonls.enable = true;
            lua-ls = {
              enable = true;
              settings.telemetry.enable = false;
            };
            nixd.enable = true;
            sqls.enable = true;
            svelte.enable = true;
            tailwindcss.enable = true;
            tsserver.enable = true;
            typos-lsp.enable = true;
            yamlls.enable = true;
          };
        };
        lsp-format.enable = true;
        lsp-lines.enable = true; # render diagnostics using virtual lines on top of the real line of code
        lspkind.enable = true; # add pictograms

        nvim-tree.enable = true;
        #neo-tree.enable = true;
				telescope.enable = true;
        todo-comments.enable = true;

        # treesitter
        treesitter = {
          enable = true;
          folding = false;
          indent = true;
        };
        treesitter-context.enable = true;
        treesitter-refactor = {
          enable = true;
          highlightCurrentScope.enable = true;
          highlightDefinitions.enable = true;
          navigation.enable = true;
          smartRename.enable = true;
        };
        treesitter-textobjects = {
          enable = true;
          lspInterop.enable = true;
        };

        ts-autotag.enable = true;
			};
		};
	};
}
