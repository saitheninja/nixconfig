{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    configNixvim.enable = lib.mkEnableOption "Adds Neovim, configured with nixvim.";
  };

  config = lib.mkIf config.configNixvim.enable {
    environment.variables.EDITOR = "nvim";

    programs.nixvim = {
      enable = true;

      extraPackages = with pkgs; [
        # neovim
        wl-clipboard # wayland clipboard

        # conform
        nixfmt-rfc-style
        shfmt # bash
        stylua

        # telescope
        fd # better find
        fzf # fuzzy find
        ripgrep # faster grep
      ];

      # clipboard.register = "unnamedplus"; # use system clipboard as default register
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

        # folding
        foldenable = true;
        foldcolumn = "0"; # width
        foldlevel = 99; # minimum depth that will be folded by default
        foldlevelstart = 99; # fold depth open when a new buffer is opened

        # scroll
        scrolloff = 999; # minimum number of rows to keep around the cursor
        sidescrolloff = 10; # minimum number of columns to keep around the cursor

        # cursor
        cursorline = true; # highlight cursor line
        cursorlineopt = "number,line"; # number, line, both, screenline

        # ...rest
        #colorcolumn = "80"; # column line
        signcolumn = "yes"; # text shifts when column gets toggled, so just leave it on
        termguicolors = true; # enable 24-bit colours
        virtualedit = "block"; # when in visual block mode, the cursor can move freely in columns
        #visualbell = true;

        # suggested by auto-session; adds winpos, localoptions
        sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,winpos,localoptions";
      };

      colorschemes = {
        cyberdream = {
          enable = true;

          settings = {
            italic_comments = true;
            transparent = true;
          };
        };
      };

      plugins = {
        auto-session.enable = true;

        lualine = {
          enable = true; # statusline (bottom of window or global), tabline (top global), winbar (top of window)

          extensions = [
            "nvim-dap-ui"
            "oil"
            "trouble"
          ];

          componentSeparators = {
            left = "";
            right = "";
          };
          sectionSeparators = {
            left = "";
            right = "";
          };

          sections = {
            lualine_a = [ { name = "mode"; } ];
            lualine_b = [
              { name = "branch"; }
              { name = "diff"; }
              { name = "diagnostics"; }
            ];
            lualine_c = [
              {
                name = "filename";
                extraConfig = {
                  path = 1;
                };
              }
              { name = "searchcount"; }
            ];
            lualine_x = [ { name = "filetype"; } ];
            lualine_y = [
              { name = "progress"; }
              { name = "selectioncount"; }
            ];
            lualine_z = [ { name = "location"; } ];
          };

          inactiveSections = {
            lualine_b = [
              {
                name = "diff";
                extraConfig = {
                  color = "Conceal";
                  colored = false;
                };
                #color = "Conceal"; # doesn't work
              }
              {
                name = "diagnostics";
                extraConfig = {
                  color = "Conceal";
                  colored = false;
                };
              }
            ];
            lualine_c = [
              {
                name = "filename";
                extraConfig = {
                  color = "Conceal";
                  colored = false;
                };
              }
            ];
            lualine_x = [
              {
                name = "progress";
                extraConfig = {
                  color = "Conceal";
                  colored = false;
                };
              }
              {
                name = "location";
                extraConfig = {
                  color = "Conceal";
                  colored = false;
                };
              }
            ];
          };

          tabline = {
            lualine_a = [ { name = "buffers"; } ];
            lualine_z = [ { name = "tabs"; } ];
          };
        };

        comment.enable = true; # "gc{object/motion}" and "gb{object}" to comment
        notify.enable = true; # fancy notification popup
        nvim-ufo.enable = true; # better folding
        oil.enable = true; # file explorer as a buffer

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

        trouble.enable = true; # view problems
        which-key.enable = true; # show shortcuts

        virt-column = {
          enable = true; # allow text characters to be used as colorcolumn

          settings = {
            enabled = true;

            char = "│";
            highlight = "Conceal"; # default "NonText"
            virtcolumn = "80";
          };
        };

        # snippets
        friendly-snippets.enable = true;
        luasnip.enable = true;

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

        conform-nvim = {
          enable = true; # formatter

          # formatOnSave = {
          #   lspFallback = true;
          #   timeoutMs = 500;
          # };

          formattersByFt = {
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
              ]
            ];
            typescript = [
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

            json = [
              [
                "prettier_d"
                "prettier"
              ]
            ];
            yaml = [
              [
                "prettier_d"
                "prettier"
              ]
            ];
            markdown = [
              [
                "prettier_d"
                "prettier"
              ]
            ];

            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            sh = [ "shfmt" ];

            # run sequentially
            # css = [ ...formatters ]

            # run first available
            # html = [[ ...formatters ]]

            # all filetypes
            # "*" = [ "trim_newlines" ]; 

            # filetypes that don't have a formatter configured
            # "_" = [
            #   "trim_newlines"
            #   "trim_whitespace"
            # ];
          };

          notifyOnError = true;
        };

        dap = {
          enable = true; # debugger

          extensions = {
            dap-ui.enable = true;
            dap-virtual-text.enable = true;
          };
        };

        # git
        diffview.enable = true;
        gitsigns.enable = true; # show git status as coloured line in signcolumn
        neogit = {
          enable = true;

          settings.integrations = {
            diffview = true;
            telescope = true;
          };
        };

        # linters
        lint = {
          enable = true;

          lintersByFt = {
            css = [ "stylelint" ];

            javascript = [ "eslint" ];
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
            typos-lsp.enable = false;
            yamlls.enable = true;
          };
        };
        #lsp-format.enable = true;
        #lsp-lines.enable = true; # render diagnostics using virtual lines on top of the real line of code
        lspkind.enable = true; # add pictograms for lsp completion items

        # treesitter
        indent-blankline = {
          enable = true; # show indent guides

          settings = {
            indent = {
              char = "│";
            };

            scope = {
              enabled = true; # underline top and bottom of scope

              # include.node_type = {
              #   nix = [ "expression" "binding" ];
              #   "*"  = ["*"];
              # };

              show_end = false;
              show_exact_scope = true;
              show_start = false;
            };
          };
        };
        nvim-autopairs.enable = true; # pair brackets, quotes
        rainbow-delimiters.enable = true; # matching brackets get matching colours
        treesitter = {
          enable = true; # parse text as Abstract Syntax Tree (AST) for better understanding

          folding = true;
          incrementalSelection = {
            enable = true;

            # keymaps = {
            #   initSelection = "gnn";
            #   nodeDecremental = "grm";
            #   nodeIncremental = "grn";
            #   scopeIncremental = "grc";
            # };
          };
          indent = true;
          nixvimInjections = true; # enable nixvim specific injections, like lua highlighting in extraConfigLua
        };

        treesitter-context = {
          enable = true; # sticky scope

          settings = {
            enable = false; # toggle with TSContextToggle
          };
        };

        treesitter-textobjects = {
          enable = true;
          lspInterop.enable = true;
        };

        ts-autotag.enable = true; # autoclose and autorename html tags using treesitter
        ts-context-commentstring.enable = true; # automatically use correct comment syntax

        # terminal
        #toggleterm.enable = true;
        #zellij.enable = true; # terminal multiplexer
      };

      # keymaps
      globals.mapleader = " ";
      keymaps = [
        # neovim settings
        {
          action = "<Cmd>lua vim.wo.wrap = not vim.wo.wrap<CR>"; # :h <Cmd>
          key = "<leader>nw";
          mode = "n";
          options = {
            desc = "Neovim: toggle line wrap";
          };
        }
        {
          action = "<Cmd>nohlsearch<CR>"; # :noh[lsearch]
          key = "<leader>n/";
          mode = "n";
          options = {
            desc = "Neovim: turn off search highlight (search commands turns on)";
          };
        }
        # neovim buffers
        {
          action = "<Cmd>bnext<CR>";
          key = "<leader>bn";
          mode = "n";
          options = {
            desc = "Neovim: buffer next";
          };
        }
        {
          action = "<Cmd>bprevious<CR>";
          key = "<leader>bp";
          mode = "n";
          options = {
            desc = "Neovim: buffer previous";
          };
        }
        {
          action = "<Cmd>bprevious<CR>";
          key = "<leader>bN";
          mode = "n";
          options = {
            desc = "Neovim: buffer previous";
          };
        }
        {
          action = "<Cmd>bfirst<CR>";
          key = "<leader>bf";
          mode = "n";
          options = {
            desc = "Neovim: buffer first";
          };
        }
        {
          action = "<Cmd>blast<CR>";
          key = "<leader>bl";
          mode = "n";
          options = {
            desc = "Neovim: buffer last";
          };
        }
        {
          action = "<Cmd>ball<CR>"; # see also :unh[ide]
          key = "<leader>ba";
          mode = "n";
          options = {
            desc = "Neovim: one window for each buffer";
          };
        }

        # auto-session
        {
          action = "<Cmd>SessionSave<CR>";
          key = "<leader>sw";
          mode = "n";
          options = {
            desc = "auto-session: write session";
          };
        }
        {
          action = "<Cmd>SessionRestore<CR>";
          key = "<leader>sr";
          mode = "n";
          options = {
            desc = "auto-session: restore session";
          };
        }
        {
          action = "<Cmd>Autosession search<CR>";
          key = "<leader>ss";
          mode = "n";
          options = {
            desc = "auto-session: search sessions (<C-s> restore, <C-d> delete)";
          };
        }

        # conform
        {
          action = "<Cmd>Format<CR>";
          key = "<leader>cf";
          mode = [
            "n"
            "v"
          ];
          options = {
            desc = "Conform: format selected text/buffer";
          };
        }

        # neogit
        {
          action = "<Cmd>Neogit<CR>";
          key = "<leader>gs";
          mode = "n";
          options = {
            desc = "Neogit: open status buffer in new tab";
          };
        }

        # nvim-ufo
        {
          action = "<Cmd>Ufo openAllFolds<CR>";
          key = "<leader>zR";
          mode = "n";
          options = {
            desc = "UFO: open all folds";
          };
        }
        {
          action = "<Cmd>Ufo closeAllFolds<CR>";
          key = "<leader>zM";
          mode = "n";
          options = {
            desc = "UFO: close all folds";
          };
        }

        # oil
        {
          action = "<Cmd>Oil<CR>";
          key = "<leader>oe";
          mode = "n";
          options = {
            desc = "Oil: open parent directory";
          };
        }

        # telescope
        {
          action = "<Cmd>Telescope find_files<CR>";
          key = "<leader>ff";
          mode = "n";
          options = {
            desc = "Telescope: find files";
          };
        }
        {
          action = "<Cmd>Telescope live_grep<CR>";
          key = "<leader>fg";
          mode = "n";
          options = {
            desc = "Telescope: live grep";
          };
        }
        {
          action = "<Cmd>Telescope buffers<CR>";
          key = "<leader>fb";
          mode = "n";
          options = {
            desc = "Telescope: buffers";
          };
        }
        {
          action = "<Cmd>Telescope help_tags<CR>";
          key = "<leader>fh";
          mode = "n";
          options = {
            desc = "Telescope: help tags";
          };
        }

        # treesitter
        {
          action = "<Cmd>TSContextToggle<CR>";
          key = "<leader>tc";
          mode = "n";
          options = {
            desc = "Treesitter: toggle sticky context";
          };
        }

        # trouble
        {
          action = "<Cmd>TroubleToggle<CR>";
          key = "<leader>xx";
          mode = "n";
          options = {
            desc = "Trouble: toggle diagnostics window";
          };
        }
      ];

      extraConfigLua = ''
        -- Conform
        vim.api.nvim_create_user_command("Format", function(args)
          local range = nil

          if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]

            range = {
              start = { args.line1, 0 },
              ["end"] = { args.line2, end_line:len() },
            }
          end

          require("conform").format({ async = true, lsp_fallback = true, range = range })
        end, { range = true })

        -- indent-blankline + rainbow-delimiters
        -- :Telescope highlights
        local highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        }
        local hooks = require "ibl.hooks"

        -- create the highlight groups in the highlight setup hook, so that they are reset every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
          vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
          vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
          vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
          vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
          vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
          vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
        end)

        vim.g.rainbow_delimiters = { highlight = highlight }
        require("ibl").setup { scope = { highlight = highlight } }

        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      '';
    };
  };
}
