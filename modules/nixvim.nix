{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    configNixvim.enable = lib.mkEnableOption "Add Neovim, configured with nixvim.";
  };

  config = lib.mkIf config.configNixvim.enable {
    environment.variables.EDITOR = "nvim";

    programs.nixvim = {
      enable = true;

      extraPackages = with pkgs; [
        # neovim
        wl-clipboard # wayland clipboard utils

        # conform
        nixfmt-rfc-style
        stylua

        # telescope
        fd # better find
        fzf # fuzzy find
        ripgrep # faster grep
      ];

      clipboard = {
        register = "unnamedplus"; # use system clipboard as default register
        providers.wl-copy.enable = true; # use wayland cli clipboard utils
      };

      opts = {
        # cursor
        cursorline = true; # highlight cursor line
        cursorlineopt = "number,line"; # number, line, both, screenline

        # folding
        # suggested by nvim-ufo
        foldenable = true;
        foldcolumn = "auto:9"; # width
        foldlevel = 99; # minimum depth that will be folded by default
        foldlevelstart = 99; # fold depth open when a new buffer is opened

        # indents
        autoindent = true; # copy indent from current line when starting a new line
        smartindent = true; # smart autoindent when starting a new line
        expandtab = true; # expand tabs to spaces
        shiftwidth = 2; # number of spaces to use for each step of indent
        tabstop = 2; # number of spaces that a tab counts for
        breakindent = true; # wrapped lines will get visually indented

        # line numbers
        number = true;
        relativenumber = true;

        # scroll
        scrolloff = 999; # minimum number of screen lines to keep visible around the cursor
        sidescrolloff = 10; # minimum number of screen columns to keep visible around the cursor

        # search
        ignorecase = true; # ignore case if all lowercase
        smartcase = true; # case-sensitive if mixed-case
        inccommand = "split"; # incremental preview for substitute

        # sessions
        # suggested by auto-session; adds winpos, localoptions
        sessionoptions = "blank,buffers,curdir,folds,help,localoptions,tabpages,terminal,winpos,winsize";

        # ...rest
        colorcolumn = "81";
        signcolumn = "yes"; # text shifts when column gets toggled, so just leave it on
        termguicolors = true; # enable 24-bit colours
        virtualedit = "block"; # when in visual block mode, the cursor can move freely in columns
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
        # snippets
        friendly-snippets.enable = true;
        luasnip.enable = true;

        # debugging
        dap = {
          enable = true; # debugger

          extensions = {
            dap-ui.enable = true;
            dap-virtual-text.enable = true;
          };
        };

        # formatting
        conform-nvim = {
          enable = true; # formatter

          formattersByFt = {
            html = [ "prettier" ];

            css = [ "prettier" ];

            javascript = [ "prettier" ];
            typescript = [ "prettier" ];

            svelte = [ "prettier" ];

            json = [ "prettier" ];
            yaml = [ "prettier" ];

            markdown = [ "prettier" ];

            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
          };

          notifyOnError = true;
        };

        # git
        diffview.enable = true; # diffview tabpage, merge tool, file history
        gitsigns = {
          enable = true; # show git diffs as coloured symbols in signcolumn

          settings = {
            current_line_blame_opts = {
              delay = 0;
            };
          };
        };
        neogit = {
          enable = true; # git interface

          settings.integrations = {
            diffview = true;
            telescope = true;
          };
        };

        # language servers
        lsp = {
          enable = true;

          servers = {
            svelte.enable = true;
            tailwindcss.enable = true;
            tsserver.enable = true; # typescript

            # gdscript.enable = true;
            lua-ls = {
              enable = true;
              settings.telemetry.enable = false;
            };
            nixd.enable = true;
            typos-lsp.enable = true;
            # yamlls.enable = true;

            # from vscode-langservers-extracted
            cssls.enable = true;
            eslint.enable = true;
            html.enable = true;
            jsonls.enable = true;
          };
        };
        lspkind.enable = true; # add pictograms for lsp completion items

        # linting
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

        # testing
        neotest = {
          enable = true;

          adapters = {
            vitest.enable = true;
          };
        };

        # treesitter
        #comment.enable = true; # "gc{object/motion}" and "gb{object}" to comment
        indent-blankline = {
          enable = true; # show indent guides

          settings = {
            indent = {
              char = "⎸";
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
        # treesitter-textobjects = {
        #   enable = true;
        #   lspInterop.enable = true;
        # };
        ts-autotag.enable = true; # autoclose and autorename html tags using treesitter
        ts-context-commentstring.enable = true; # automatically use correct comment syntax

        # ui
        dressing.enable = true;
        fidget.enable = true; # notifications & lsp progress
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
                  path = 1; # relative path
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
                  path = 1;
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
        nvim-ufo = {
          enable = true; # better folding

          #enableGetFoldVirtText = true;
          # from nvim-ufo docs: display no. of folded lines
          # foldVirtTextHandler = ''
          #   function(virtText, lnum, endLnum, width, truncate)
          #     local newVirtText = {}
          #     local suffix = (' … ↴ %d '):format(endLnum - lnum) 
          #     local sufWidth = vim.fn.strdisplaywidth(suffix)
          #     local targetWidth = width - sufWidth
          #     local curWidth = 0
          #
          #     for _, chunk in ipairs(virtText) do
          #       local chunkText = chunk[1]
          #       local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          #
          #       if targetWidth > curWidth + chunkWidth then
          #         table.insert(newVirtText, chunk)
          #       else
          #         chunkText = truncate(chunkText, targetWidth - curWidth)
          #         local hlGroup = chunk[2]
          #         table.insert(newVirtText, {chunkText, hlGroup})
          #         chunkWidth = vim.fn.strdisplaywidth(chunkText)
          #
          #         -- str width returned from truncate() may less than 2nd argument, need padding
          #         if curWidth + chunkWidth < targetWidth then
          #           suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          #         end
          #         break
          #       end
          #
          #       curWidth = curWidth + chunkWidth
          #     end
          #
          #     table.insert(newVirtText, {suffix, 'MoreMsg'})
          #     return newVirtText
          #   end
          # '';
        };
        trouble.enable = true; # view problems
        which-key.enable = true; # show shortcuts

        # ...rest
        auto-session.enable = true; # session manager
        oil = {
          enable = true; # file explorer as a buffer

          settings = {
            delete_to_trash = true;
          };
        };
        telescope = {
          enable = true; # popup fuzzy finder, with previews

          extensions = {
            fzf-native.enable = true; # fzf sorter written in C
            media-files.enable = true; # preview media files
            ui-select.enable = true; # set vim.ui.select to telescope
            undo.enable = true; # view and search undo tree
          };

          # provided to the require('telescope').setup function
          settings = {
            pickers = {
              buffers = {
                mappings = {
                  # normal mode
                  n = {
                    "dd" = {
                      __raw = "require('telescope.actions').delete_buffer";
                    };
                  };
                };
              };
            };
          };
        };
      };

      extraPlugins = with pkgs.vimPlugins; [ package-info-nvim ];

      # keymaps
      globals.mapleader = " ";
      keymaps = [
        # :h <Cmd>
        # <Cmd> does not change modes
        # command is not echoed so no need for <silent>

        # neovim settings
        {
          action = "<Cmd>lua vim.wo.wrap = not vim.wo.wrap<CR>";
          key = "<leader>nw";
          mode = "n";
          options = {
            desc = "Neovim: toggle line wrap";
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
        {
          action = "<Cmd>bdelete<CR>";
          key = "<leader>bd";
          mode = "n";
          options = {
            desc = "Neovim: buffer delete";
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
          action = "<Cmd>ConformFormat<CR>";
          key = "<leader>cf";
          mode = [
            "n"
            "v"
          ];
          options = {
            desc = "Conform: format selected text/buffer";
          };
        }

        # gitsigns
        {
          action = "<Cmd>Gitsigns toggle_current_line_blame<CR>";
          key = "<leader>gb";
          mode = "n";
          options = {
            desc = "Gitsigns: toggle line blame";
          };
        }
        {
          action = "<Cmd>Gitsigns toggle_deleted<CR>";
          key = "<leader>gd";
          mode = "n";
          options = {
            desc = "Gitsigns: toggle deleted";
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
        # built in commands change foldlevel, ufo commands don't
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
        {
          action = "<Cmd>Ufo openFoldsExceptKinds<CR>";
          key = "<leader>zr";
          mode = "n";
          options = {
            desc = "UFO: open folds";
          };
        }
        {
          action = "<Cmd>Ufo closeFoldsWith<CR>";
          key = "<leader>zm";
          mode = "n";
          options = {
            desc = "UFO: close folds";
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

        # package-info
        {
          action = "<Cmd>lua require('package-info').show({ force = true })<CR>"; # force refetch every time
          key = "<leader>ns";
          mode = "n";
          options = {
            desc = "Package Info: run `npm outdated --json`";
          };
        }
        {
          action = "<Cmd>lua require('package-info').change_version()<CR>"; # force refetch every time
          key = "<leader>nv";
          mode = "n";
          options = {
            desc = "Package Info: change version";
          };
        }

        # telescope file pickers
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
        # telescope vim pickers
        {
          action = "<Cmd>Telescope autocommands<CR>";
          key = "<leader>fa";
          mode = "n";
          options = {
            desc = "Telescope: autocommands";
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
          action = "<Cmd>Telescope commands<CR>";
          key = "<leader>fc";
          mode = "n";
          options = {
            desc = "Telescope: plugin/user commands";
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
        {
          action = "<Cmd>Telescope marks<CR>";
          key = "<leader>fm";
          mode = "n";
          options = {
            desc = "Telescope: marks";
          };
        }
        {
          action = "<Cmd>Telescope oldfiles<CR>";
          key = "<leader>fo";
          mode = "n";
          options = {
            desc = "Telescope: previously opened files";
          };
        }
        {
          action = "<Cmd>Telescope current_buffer_tags<CR>";
          key = "<leader>ft";
          mode = "n";
          options = {
            desc = "Telescope: buffer tags";
          };
        }
        {
          action = "<Cmd>Telescope vim_options<CR>";
          key = "<leader>fv";
          mode = "n";
          options = {
            desc = "Telescope: vim options";
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
        {
          action = "<Cmd>TroubleToggle workspace_diagnostics<CR>";
          key = "<leader>xw";
          mode = "n";
          options = {
            desc = "Trouble: toggle workspace diagnostics";
          };
        }
        {
          action = "<Cmd>TroubleToggle document_diagnostics<CR>";
          key = "<leader>xd";
          mode = "n";
          options = {
            desc = "Trouble: toggle document diagnostics";
          };
        }
        {
          action = "<Cmd>TroubleToggle quickfix<CR>";
          key = "<leader>xq";
          mode = "n";
          options = {
            desc = "Trouble: toggle quickfix window";
          };
        }
        {
          action = "<Cmd>TroubleToggle loclist<CR>";
          key = "<leader>xl";
          mode = "n";
          options = {
            desc = "Trouble: toggle locationlist window";
          };
        }
      ];

      extraConfigLua = ''
        -- from conform docs 
        -- make format command
        vim.api.nvim_create_user_command("ConformFormat", function(args)
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

        -- from indent-blankline docs
        -- rainbow-delimiters integration
        -- `:Telescope highlights` to preview colours
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

      withNodeJs = false;
      withRuby = false; # why is this default true?
    };
  };
}
