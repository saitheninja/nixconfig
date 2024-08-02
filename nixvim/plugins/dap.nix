{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      vscode-js-debug # Node debugging
    ];

    # debug adapter protocol
    plugins.dap = {
      enable = true;

      #adapters = {
      #  servers = {
      #    pwa-node = {
      #      host = "localhost";
      #      port = ''''${port}'';
      #      executable = {
      #        command = "node";
      #        args = [
      #          "${pkgs.vscode-js-debug}/bin/js-debug"
      #          ''''${port}''
      #        ];
      #      };
      #    };
      #  };
      #};

      configurations = {
        svelte = [
          {
            type = "pwa-node"; # adapter name
            request = "launch"; # attach or launch
            name = "Node launch file";
            program = ''''${file}'';
            cwd = ''''${workspaceFolder}'';
          }
          {
            type = "pwa-node";
            request = "attach";
            name = "Attach";
            processId = # lua
              ''
                require("dap.utils").pick_process;
              '';
            cwd = ''''${workspaceFolder}'';
          }
        ];
        #{
        #  name = "Node attach";
        #  request = "attach";
        #  type = "pwa-node";
        #  processId = # lua
        #    ''
        #      require'dap.utils'.pick_process
        #    '';
        #  cwd = "${workspaceFolder}";
        #};

        # typescript = {
        #   name = "ts-launch";
        #   request = "launch";
        #   type = "pwa-node";
        # };
      };

      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };

    extraConfigLua = # lua
      ''
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "8123",
          executable = {
            command = "node",
            args = {"${pkgs.vscode-js-debug}/bin/js-debug", "8123"},
          }
        }
      '';
  };
}
