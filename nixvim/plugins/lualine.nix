{
  # statusline (bottom of window or global), tabline (top global), winbar (top of window)
  programs.nixvim.plugins.lualine = {
    enable = true;

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

      lualine_x = [
        # list active LSPs
        {
          name.__raw = # lua
            ''
              function ()
                local buf_clients = vim.lsp.get_clients({bufnr = 0}) -- 0 means this buffer
                if next(buf_clients) == nil then
                  return "No LSPs"
                end

                local buf_client_names = {}
                for _, client in pairs(buf_clients) do
                  table.insert(buf_client_names, client.name)
                end

                return table.concat(buf_client_names, ", ")
              end
            '';
          extraConfig = {
            color = "Conceal";
          };
        }
        { name = "filetype"; }
      ];

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
            # mode = 2; # buffer name + buffer index
            mode = 4; # buffer name + buffer number
            show_filename_only = false; # show shortened relative path
          };
        }
      ];

      lualine_z = [ { name = "tabs"; } ];
    };
  };
}
