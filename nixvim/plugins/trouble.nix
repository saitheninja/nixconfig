{
  programs.nixvim = {
    # LSP diagnoistics, symbols, etc.
    plugins.trouble = {
      enable = true;
    };

    keymaps = [
      {
        action = "";
        key = "<leader>x";
        mode = "n";
        options = {
          desc = "+view LSP diagnostics with Trouble";
        };
      }
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
  };
}
