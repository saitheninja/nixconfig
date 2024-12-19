{ pkgs, ... }:

{
  programs.nixvim = {
    extraPackages = with pkgs; [
      nixfmt-rfc-style
      stylua
    ];

    # formatter
    plugins.conform-nvim = {
      enable = true;

      settings = {
        formatters_by_ft = {
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
          zig = [ "zigfmt" ];
        };

        format_on_save = # lua
          ''
            function(bufnr)
              if vim.g.disable_format_on_save or vim.b[bufnr].disable_format_on_save then
                return
              end

              return { timeout_ms = 5000, lsp_fallback = true }
             end
          '';

        notify_no_formatters = false;
        notify_on_error = false;
      };
    };

    keymaps = [
      {
        action = "";
        key = "<leader>c";
        mode = [
          "n"
          "v"
        ];
        options = {
          desc = "+format with Conform";
        };
      }

      # format
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
      {
        action = "<Cmd>ConformAsyncFormat<CR>";
        key = "<leader>cc";
        mode = [
          "n"
          "v"
        ];
        options = {
          desc = "Conform: format selected text/buffer";
        };
      }

      # format on save setting
      {
        action = "<Cmd>ConformFormatOnSaveDisable!<CR>";
        key = "<leader>cd";
        mode = "n";
        options = {
          desc = "Conform: disable format on save";
        };
      }
      {
        action = "<Cmd>ConformFormatOnSaveEnable<CR>";
        key = "<leader>ce";
        mode = "n";
        options = {
          desc = "Conform: enable format on save";
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

        -- vim.api.nvim_create_user_command("ConformFormatOnSaveDisable", function(args)
        --   if args.bang then
        --     -- ConformFormatOnSaveDisable! will disable formatting just for this buffer
        --     vim.b.disable_format_on_save = true
        --   else
        --     vim.g.disable_format_on_save = true
        --   end
        -- end, {
        --   desc = "Disable Conform format on save",
        --   bang = true,
        -- })

        -- vim.api.nvim_create_user_command("ConformFormatOnSaveEnable", function()
        --   vim.b.disable_format_on_save = false
        --   vim.g.disable_format_on_save = false
        -- end, {
        --   desc = "Enable Conform format on save",
        -- })
      '';

    userCommands = {
      # from conform docs
      ConformAsyncFormat = {
        # addr = lines; # special characters refer to range of: lines (default), arguments, buffers, loaded_buffers, windows, tabs, quickfix, other
        # bang = false; # take force/override
        # bar = false; # pipe/chain commands
        command.__raw = # lua
          ''
            function(opts)
              -- for k, v in pairs(opts) do
              --   print(k, v)
              -- end
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

                -- for a, b in pairs(range) do
                --   print(a)
                --   for x, y in pairs(b) do
                --     print(x, y)
                --   end
                -- end
              end

              require("conform").format({ async = true, lsp_format = "fallback", range = range })
            end
          '';
        # complete = null; # autocomplete arguments of command with buffer name, dir, etc.
        # count = null; # accept a count
        desc = "Conform: format buffer or selected range"; # range doesn't work?
        # force = false; # overwrite existing command
        # keepscript = false # for verbose messages, use location of where the command was invoked, instead of where the command was defined
        # nargs = 0; # number of arguments that the command takes: 0 (default), 1, “*” (any), “?” (0 or 1), “+” (>0)
        range = 2; # number of items in the command range: 0, 1, or 2
        # register = false; # first argument to the command can be an optional register
      };

      ConformFormatOnSaveDisable = {
        bang = true;
        command.__raw = # lua
          ''
            function(args)
               if args.bang then
                 -- FormatDisable! will disable formatting just for this buffer
                 vim.b.disable_format_on_save = true
               else
                 vim.g.disable_format_on_save = true
               end
            end
          '';
        desc = "Disable Conform format on save";
      };

      ConformFormatOnSaveEnable = {
        command.__raw = # lua
          ''
            function()
              vim.b.disable_format_on_save = false
              vim.g.disable_format_on_save = false
            end
          '';
        desc = "Enable Conform format on save";
      };
    };
  };
}
