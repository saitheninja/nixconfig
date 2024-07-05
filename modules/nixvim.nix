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
    # make default editor
    environment.variables.EDITOR = "nvim";

    programs.nixvim = {
      enable = true;

      # extra packages to install with nix
      extraPackages = with pkgs; [
        # neovim
        wl-clipboard # wayland clipboard utils

        # conform
        nixfmt-rfc-style
        stylua

        # LSPs
        # zls # zig # waiting for 0.13 to hit unstable, to match zig version

        # telescope
        fd # better find
        fzf # fuzzy find
        ripgrep # faster grep
      ];
      extraPlugins = with pkgs.vimPlugins; [ package-info-nvim ];

      # config options
      clipboard = {
        register = "unnamedplus"; # use system clipboard as default register
        providers.wl-copy.enable = true; # use wl-clipboard CLI utils
      };
      globals = {
        have_nerd_font = true; # Cascadia Code NF
        mapleader = " "; # set leader key to spacebar
      };
      opts = {
        # cursor
        cursorline = true; # highlight cursor line
        cursorlineopt = "number,line"; # number, line, both, screenline

        # folding
        foldenable = true;
        foldcolumn = "auto:9"; # width
        # suggested by nvim-ufo
        foldlevel = 99; # minimum depth that will be folded by default
        foldlevelstart = 99; # fold depth open when a new buffer is opened

        # indents
        autoindent = true; # copy indent from current line when starting a new line
        smartindent = true; # smart autoindent when starting a new line
        expandtab = true; # expand tabs to spaces
        shiftwidth = 2; # number of spaces to use for each step of indent
        tabstop = 2; # number of spaces that a tab counts for
        breakindent = true; # wrapped lines will get visually indented
        showbreak = "↳"; # string to put at the start of wrapped lines

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
        # auto-session suggests adding: winpos, localoptions
        sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,winpos,winsize";

        # ...rest
        colorcolumn = "81"; # display vertical line
        signcolumn = "yes:1"; # text shifts when column gets toggled, so just leave it on
        termguicolors = true; # enable 24-bit colours
        virtualedit = "block"; # when in visual block mode, the cursor can move freely in columns
      };

      # colours
      colorschemes = {
        cyberdream = {
          enable = true;

          settings = {
            italic_comments = true;
            transparent = true;
          };
        };
      };
      highlightOverride = {
        NonText = {
          link = "Conceal"; # override NonText with link to Conceal
        };
      };

      plugins = {
        # completions
        cmp = {
          enable = true;

          settings = {
            mapping = {
              # defaults
              "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item())";
              "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item())";

              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";

              "<C-Space>" = "cmp.mapping.complete()"; # trigger completions
              "<C-e>" = "cmp.mapping.abort()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
            };

            snippets.expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';

            sources = [
              { name = "nvim_lsp_signature_help"; }
              { name = "nvim_lsp"; }
              { name = "nvim_lua"; }
              { name = "luasnip"; }
              { name = "buffer"; }
              { name = "emoji"; }
            ];

            window = {
              completion = {
                border = "single";
                scrolloff = 5;
                winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None";
              };

              documentation = {
                border = "single";
                winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None";
              };
            };
          };
        };
        cmp-buffer.enable = true; # text within current buffer
        # cmp-cmdline.enable = true;
        # cmp-cmdline-history.enable = true;
        # cmp-dap.enable = true;
        cmp-emoji.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-nvim-lsp-signature-help.enable = true; # display function signature with the current parameter emphasized
        cmp-nvim-lua.enable = true; # neovim Lua API
        # cmp-path.enable = true; # file system paths
        # cmp-treesitter.enable = true;
        cmp_luasnip.enable = true;
        # snippets
        friendly-snippets.enable = true;
        luasnip.enable = true; # snippet engine - required for completions

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
            rust = [ "rustfmt" ];
            zig = [ "zig fmt" ];
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

          inlayHints = true;
          keymaps = {
            # Mappings for `vim.lsp.buf.<action>` functions
            lspBuf = {
              grn = "rename";
              grr = "references";
              grd = "definition";
              gri = "implementation";
              grt = "type_definition";
            };
          };

          servers = {
            # from vscode-langservers-extracted
            cssls = {
              enable = true;
              settings = {
                css.lint.unknownAtRules = "ignore"; # ignore tailwind stuff
              };
            };
            eslint.enable = true;
            html.enable = true;
            jsonls.enable = true;

            svelte.enable = true;
            tailwindcss.enable = true;
            tsserver.enable = true; # typescript

            # gdscript.enable = true;
            lua-ls = {
              enable = true;
              settings.telemetry.enable = false;
            };
            nixd.enable = true;
            rust-analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
            };
            # typos-lsp.enable = true;
            # yamlls.enable = true;
            # zls.enable = true;
          };
        };
        lspkind.enable = true; # add pictograms for lsp completion items
        inc-rename.enable = true; # preview rename while typing

        # linting
        lint = {
          enable = true;

          lintersByFt = {
            css = [ "stylelint" ];

            javascript = [ "eslint" ];
            typescript = [ "eslint" ];
            svelte = [ "eslint" ];
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
        comment.enable = true; # "gc{object/motion}" and "gb{object}" to comment
        indent-blankline = {
          enable = true; # show indent guides

          settings = {
            scope = {
              enabled = true; # highlight indent and underline top and bottom of scope

              show_end = true;
              show_exact_scope = true;
              show_start = true;
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
            enable = false; # toggle with :TSContextToggle
          };
        };
        treesitter-textobjects = {
          enable = true;

          lspInterop.enable = true;
        };
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
            lualine_a = [
              {
                name = "buffers";
                extraConfig = {
                  mode = 2; # buffer name + buffer index
                  show_filename_only = false;
                };
              }
            ];
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
        trouble.enable = true; # window for diagnostics, info provided by lsp, etc.
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
                  # insert mode
                  i = {
                    "<C-d>" = {
                      __raw = "require('telescope.actions').delete_buffer";
                    };
                  };
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
        {
          action = "<Cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
          key = "<leader>nh";
          mode = "n";
          options = {
            desc = "Neovim: toggle lsp inlay hint";
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

        # inc-rename
        {
          action = ":IncRename ";
          key = "<leader>rn";
          mode = "n";
          options = {
            desc = "Inc-rename: start rename";
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
          action = "<Cmd>Trouble diagnostics toggle<CR>";
          key = "<leader>xx";
          mode = "n";
          options = {
            desc = "Trouble: project diagnostics";
          };
        }
        {
          action = "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>";
          key = "<leader>xX";
          mode = "n";
          options = {
            desc = "Trouble: buffer diagnostics";
          };
        }
        {
          action = "<Cmd>Trouble symbols toggle focus=false<CR>";
          key = "<leader>xs";
          mode = "n";
          options = {
            desc = "Trouble: LSP symbols";
          };
        }
        {
          action = "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>";
          key = "<leader>xl";
          mode = "n";
          options = {
            desc = "Trouble: LSP definitions/references/...";
          };
        }
        {
          action = "<Cmd>Trouble loclist toggle<CR>";
          key = "<leader>xL";
          mode = "n";
          options = {
            desc = "Trouble: location list";
          };
        }
        {
          action = "<cmd>Trouble qflist toggle<cr>";
          key = "<leader>xQ";
          mode = "n";
          options = {
            desc = "Trouble: quickfix list";
          };
        }
      ];

      extraConfigLua = # lua
        ''
          -- from conform docs 
          -- make format command
          vim.api.nvim_create_user_command("ConformFormat", function(opts)
            -- for k, v in pairs(opts) do
            --   print(k, v)
            -- end

            local range = nil

            if opts.count ~= -1 then
              local end_line = vim.api.nvim_buf_get_lines(0, opts.line2 - 1, opts.line2, true)[1]

              range = {
                start = { opts.line1, 0 },
                ["end"] = { opts.line2, end_line:len() },
              }

              -- for a, b in pairs(range) do
              --   print(a)
              --   for x, y in pairs(b) do
              --     print(x, y)
              --   end
              -- end
            end
            require("conform").format({ async = true, lsp_format = "fallback", range = range })
          end, { range = true })

          -- from indent-blankline docs
          -- rainbow-delimiters integration
          -- "Setting a list of highlights for scope is currently broken" https://github.com/lukas-reineke/indent-blankline.nvim/issues/893#issuecomment-2167822070
          require("ibl").setup { scope = { highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
          } } }
          local hooks = require("ibl.hooks")
          hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        '';

      autoCmd = [
        {
          callback.__raw = # lua
            ''
              function()
                vim.highlight.on_yank()
              end
            '';
          desc = "Highlight when yanking text";
          event = "TextYankPost";
          group = "highlight_yank";
        }
      ];
      autoGroups = {
        highlight_yank = {
          clear = true;
        };
      };

      userCommands = {
        # from conform docs 
        ConformFormatBuffer = {
          # addr = lines; # special characters refer to range of: lines (default), arguments, buffers, loaded_buffers, windows, tabs, quickfix, other
          # bang = false; # take force/override
          # bar = false; # pipe/chain commands
          command.__raw = # lua
            ''
              function(opts)
                for k, v in pairs(opts) do
                  print(k, v)
                end
                -- print(opts.range) -- no. of items in the command range: 0, 1 or 2
                -- print(opts.count) -- supplied count: -1 if no range, else ending line no.
                -- print(opts.line1) -- starting line no. of command range
                -- print(opts.line2) -- ending line no. of command range

                local range = nil

                if opts.count ~= -1 then
                  -- get the actual text of the last line
                  local end_line = vim.api.nvim_buf_get_lines(0, opts.line2 - 1, opts.line2, true)[1]
                  -- get col no. of last col
                  local end_col = end_line:len()

                  -- conform fn expects a table formatted as: 
                  -- {{ "start"={ row, col }}, { "end"={ row, col }}}
                  range = {
                    ["start"] = { opts.line1, 0 },
                    ["end"] = { opts.line2, end_col },
                  }

                  for a, b in pairs(range) do
                    print(a)
                    for x, y in pairs(b) do
                      print(x, y)
                    end
                  end
                end

                require("conform").format({ async = true, lsp_format = "fallback", range = range })
              end
            '';
          # complete = null; # autocomplete arguments of command with buffer name, dir, etc.
          # count = null; # accept a count
          desc = "Conform: format buffer or selected range"; # range doesn't work? even with the extraConfigLua command
          # force = false; # overwrite existing command
          # keepscript = false # for verbose messages, use location of where the command was invoked, instead of where the command was defined
          # nargs = "*"; # number of arguments that the command takes: 0 (default), 1, “*” (any), “?” (0 or 1), “+” (>0)
          range = true; # pass in number of items in the command range: 0, 1 or 2
          # register = false; # first argument to the command can be an optional register
        };
      };

      withNodeJs = false;
      withRuby = false; # why is this default true?
    };
  };
}
