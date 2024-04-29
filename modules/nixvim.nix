{ config, lib, ... }:

{
  options = {
    configNixvim.enable = lib.mkEnableOption "Adds Neovim, configured with nixvim.";
  };

  config = lib.mkIf config.configNixvim.enable {
    programs.nixvim = {
      enable = true;

      clipboard.register = "unnamedplus"; # use system clipboard as default register
      clipboard.providers.wl-copy.enable = true; # use wayland cli clipboard utils

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
        #cursorline = true; # highlight cursor line
        #cursorlineopt = "number"; # line, number, both (line,number), screenline
        #colorcolumn = "80"; # column line
        scrolloff = 999; # minimum number of rows to keep around the cursor
        sidescrolloff = 10; # minimum number of columns to keep around the cursor
        signcolumn = "yes"; # text shifts when column gets toggled
        # splitbelow = true;
        # splitright = true;
        termguicolors = true; # enable 24-bit colours
        visualbell = true;
        virtualedit = "block"; # the cursor can be positioned where there is no actual character (in visual block mode)
      };

      colorschemes = {
        catppuccin = {
          enable = true;
          settings = {
            flavour = "mocha"; # light to dark: latte, frappe, macchiato, mocha
            transparent_background = false;
          };
        };
      };

      plugins = {
        # auto-session.enable = true; # session manager

        bufferline.enable = true; # bufferline (top)
        lualine.enable = true; # statusline (bottom)

        # completions
        cmp.enable = true;
        cmp-buffer.enable = true;
        cmp-cmdline.enable = true;
        cmp-cmdline-history.enable = true;
        cmp-dap.enable = true;
        cmp-emoji.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-nvim-lsp-signature-help.enable = true;
        cmp-nvim-lua.enable = true;
        cmp-path.enable = true;
        cmp-treesitter.enable = true;
        cmp_luasnip.enable = true;

        # formatters
        conform-nvim = {
          enable = true;
          formatOnSave = {
            lspFallback = true;
            timeoutMs = 500;
          };
          formattersByFt = {
            # run sequentially
            # python = [ "isort" "black" ];

            # run first available
            # html = [ [ "prettier_d" "prettier" ] ]; 

            css = [ "stylelint" ]; # tailwind? does prettier plugin work? rustywind?
            scss = [ "stylelint" ];
            less = [ "stylelint" ];

            html = [
              [
                "prettier_d"
                "prettier"
              ]
            ];
            javascript = [
              [
                "prettier_d"
                "prettier"
                # "eslint_d" ?
              ]
            ];
            json = [
              [
                "prettier_d"
                "prettier"
              ]
            ];
            svelte = [
              [
                "prettier_d"
                "prettier"
              ]
            ];
            typescript = [
              [
                "prettier_d"
                "prettier"
              ]
            ];

            # markdown = [
            #   [
            #     "prettierd"
            #     "prettier"
            #   ]
            # ];
            # yaml = [
            #   "yamllint"
            #   "yamlfmt"
            # ];

            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            sh = [ "shfmt" ];

            # all filetypes
            # "*" = [ "trim_newlines" ]; 

            # filetypes that don't have a formatter configured
            "_" = [
              "trim_newlines"
              "trim_whitespace"
            ];
          };
        };

        comment.enable = true; # "gc" to comment
        cursorline = {
          enable = true; # underline all instances of the word under the cursor
          cursorline = {
            number = true; # highlight line number --- options reversed??
            timeout = 500; # timeout before highlighting the line
          };
        };
        indent-blankline.enable = true; # show indent guides

        # debugger
        dap = {
          enable = true;
          extensions = {
            dap-ui.enable = true;
            dap-virtual-text.enable = true;
          };
        };

        # git
        diffview.enable = true;
        gitsigns.enable = true; # show git status as coloured line in signcolumn
        neogit.enable = true; # git client
        # laztgit.enable = true;

        # linters
        lint = {
          enable = true;
          lintersByFt = {
            css = [ "stylelint" ];

            javascript = [ "eslint" ]; # eslint_d?
            typescript = [ "eslint" ];

            svelte = [ "eslint" ];

            nix = [ "nix" ];
          };
        };

        # language servers
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
        #lsp-lines.enable = true; # render diagnostics using virtual lines on top of the real line of code
        lspkind.enable = true; # add pictograms for lsp completion items

        #neotest.enable = true # interact with tests from inside neovim

        # none-ls - diagnostics, formatting, completion
        # none-ls = {
        #   enable = true;
        # };

        notify.enable = true; # fancy notification popup
        nvim-colorizer.enable = true; # highlight css colours blue #666
        neo-tree.enable = true; # file explorer
        rainbow-delimiters.enable = true; # matching brackets get matching colours
        todo-comments.enable = true; # highlight comments like TODO
        toggleterm.enable = true;

        telescope = {
          enable = true; # popup fuzzy finder, with previews
          extensions = {
            file-browser.enable = true;
            fzf-native.enable = true; # fzf implemented in C for telescope
            media-files.enable = true; # preview media files
            ui-select.enable = true; # set vim.ui.select to telescope
            undo.enable = true; # view and search undo tree
          };
        };

        # treesitter - parse text as an AST (Abstract Syntax Tree) for better understanding
        treesitter = {
          enable = true;
          folding = true;
          indent = true;
          nixvimInjections = true; # enable nixvim specific injections, like lua highlighting in extraConfigLua
        };
        treesitter-context.enable = true;
        treesitter-refactor = {
          enable = true;
          highlightCurrentScope.enable = true;
          highlightDefinitions.enable = true; # sticky scope context to top
          navigation.enable = true; # go to definition gnd
          smartRename.enable = true;
        };
        treesitter-textobjects = {
          enable = true;
          lspInterop.enable = true;
        };
        ts-autotag.enable = true; # autoclose and autorename html tags using treesitter
        ts-context-commentstring.enable = true; # automatically use correct comment syntax

        trouble.enable = true; # view problems
        twilight.enable = true; # dim code outside bit that is being edited
        which-key.enable = true; # show shortcuts
        zellij.enable = true; # terminal multiplexer

        # snippets
        luasnip.enable = true;
        friendly-snippets.enable = true;
      };

      # keymaps
      globals.mapleader = " ";
      keymaps = [
        # neo-tree.nvim
        {
          action = "<cmd>Neotree toggle=true reveal=true<CR>"; # default action=focus position=left source=filesystem
          key = "<leader>ee";
          mode = "n";
          options = {
            desc = "Neotree toggle show files.";
          };
        }
        {
          action = "<cmd>Neotree toggle=true reveal=true source=buffers position=float<CR>";
          key = "<leader>eb";
          mode = "n";
          options = {
            desc = "Neotree toggle show buffers.";
          };
        }
        {
          action = "<cmd>Neotree toggle=true reveal=true source=git_status position=right<CR>";
          key = "<leader>eg";
          mode = "n";
          options = {
            desc = "Neotree toggle show git status.";
          };
        }

        # telescope.nvim
        {
          action = "<cmd>Telescope find_files<CR>";
          key = "<leader>ff";
          mode = "n";
          options = {
            desc = "Telescope find files.";
          };
        }
        {
          action = "<cmd>Telescope live_grep<CR>";
          key = "<leader>fg";
          mode = "n";
          options = {
            desc = "Telescope live grep.";
          };
        }
        {
          action = "<cmd>Telescope buffers<CR>";
          key = "<leader>fb";
          mode = "n";
          options = {
            desc = "Telescope buffers.";
          };
        }
        {
          action = "<cmd>Telescope help_tags<CR>";
          key = "<leader>fh";
          mode = "n";
          options = {
            desc = "Telescope help tags.";
          };
        }

        # trouble.nvim
        {
          action = "<cmd>TroubleToggle<CR>";
          key = "<leader>xx";
          mode = "n";
          options = {
            desc = "Trouble toggle.";
          };
        }
        {
          action = "<cmd>TroubleToggle workspace_diagnostics<CR>";
          key = "<leader>xw";
          mode = "n";
          options = {
            desc = "Trouble toggle workspace diagnostics.";
          };
        }
        {
          action = "<cmd>TroubleToggle document_diagnostics<CR>";
          key = "<leader>xd";
          mode = "n";
          options = {
            desc = "Trouble toggle document diagnostics.";
          };
        }
        {
          action = "<cmd>TroubleToggle quickfix<CR>";
          key = "<leader>xq";
          mode = "n";
          options = {
            desc = "Trouble toggle quickfix list.";
          };
        }
        {
          action = "<cmd>TroubleToggle loclist<CR>";
          key = "<leader>xl";
          mode = "n";
          options = {
            desc = "Trouble toggle location list."; # location list is a window-local quickfix list
          };
        }
        {
          action = "<cmd>TroubleToggle lsp_references<CR>";
          key = "gR";
          mode = "n";
          options = {
            desc = "Trouble toggle LSP references.";
          };
        }
      ];
    };
  };
}
