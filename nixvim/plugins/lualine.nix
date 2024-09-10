{
  # statusline (bottom of window or global), tabline (top global), winbar (top of window)
  programs.nixvim.plugins.lualine = {
    enable = true;

    settings = {
      extensions = [
        "nvim-dap-ui"
        "oil"
        "trouble"
      ];

      options = {
        component_separators = {
          left = "";
          right = "";
        };

        section_separators = {
          left = "";
          right = "";
        };
      };

      sections = {
        lualine_a = [
          "mode"
        ];

        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];

        lualine_c = [
          {
            __unkeyed-1 = "filename";
            path = 1; # relative path
          }
          "searchcount"
        ];

        lualine_x = [
          # list active LSPs
          {
            __unkeyed-1 = {
              __raw = # lua
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
            };
            color = "Conceal";
          }
          "filetype"
        ];

        lualine_y = [
          "progress"
          "selectioncount"
        ];

        lualine_z = [
          "location"
        ];
      };

      inactive_sections = {
        lualine_b = [
          {
            __unkeyed-1 = "diff";
            color = "Conceal";
            colored = false;
          }
          {
            __unkeyed-1 = "diagnostics";
            color = "Conceal";
            colored = false;
          }
        ];

        lualine_c = [
          {
            __unkeyed-1 = "filename";
            color = "Conceal";
            colored = false;
            path = 1;
          }
        ];

        lualine_x = [
          {
            __unkeyed-1 = "progress";
            color = "Conceal";
            colored = false;
          }
          {
            __unkeyed-1 = "location";
            color = "Conceal";
            colored = false;
          }
        ];
      };

      tabline = {
        lualine_a = [
          {
            __unkeyed-1 = "buffers";
            # mode = 2; # buffer name + buffer index
            mode = 4; # buffer name + buffer number
            show_filename_only = false; # show shortened relative path
          }
        ];

        lualine_z = [
          "tabs"
        ];
      };
    };
  };
}
