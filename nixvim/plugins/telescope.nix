{ pkgs, ... }:

{
  programs.nixvim = {
    extraPackages = with pkgs; [
      fd # better find
      fzf # fuzzy find
      ripgrep # faster grep
    ];

    # popup fuzzy finder, with previews
    plugins.telescope = {
      enable = true;

      extensions = {
        fzf-native.enable = true; # fzf sorter written in C
        media-files.enable = true; # preview media files
        ui-select.enable = true; # set vim.ui.select to telescope (used by dressing.nvim)
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

    keymaps = [
      {
        action = "";
        key = "<leader>f";
        mode = "n";
        options.desc = "+find with Telescope";
      }

      # file pickers
      {
        action = "<Cmd>Telescope find_files<CR>";
        key = "<leader>ff";
        mode = "n";
        options.desc = "Telescope: find files";
      }
      {
        action = "<Cmd>Telescope live_grep<CR>";
        key = "<leader>fg";
        mode = "n";
        options.desc = "Telescope: live grep";
      }

      # vim pickers
      {
        action = "<Cmd>Telescope autocommands<CR>";
        key = "<leader>fa";
        mode = "n";
        options.desc = "Telescope: autocommands";
      }
      {
        action = "<Cmd>Telescope buffers<CR>";
        key = "<leader>fb";
        mode = "n";
        options.desc = "Telescope: buffers";
      }
      {
        action = "<Cmd>Telescope commands<CR>";
        key = "<leader>fc";
        mode = "n";
        options.desc = "Telescope: plugin/user commands";
      }
      {
        action = "<Cmd>Telescope help_tags<CR>";
        key = "<leader>fh";
        mode = "n";
        options.desc = "Telescope: help tags";
      }
      {
        action = "<Cmd>Telescope marks<CR>";
        key = "<leader>fm";
        mode = "n";
        options.desc = "Telescope: marks";
      }
      {
        action = "<Cmd>Telescope oldfiles<CR>";
        key = "<leader>fo";
        mode = "n";
        options.desc = "Telescope: previously opened files";
      }
      {
        action = "<Cmd>Telescope resume<CR>";
        key = "<leader>fr";
        mode = "n";
        options.desc = "Telescope: resume previous picker";
      }
      {
        action = "<Cmd>Telescope vim_options<CR>";
        key = "<leader>fv";
        mode = "n";
        options.desc = "Telescope: vim options";
      }

      # list pickers
      {
        action = "<Cmd>Telescope builtin<CR>";
        key = "<leader>fp";
        mode = "n";
        options.desc = "Telescope: built-in pickers";
      }
    ];
  };
}
