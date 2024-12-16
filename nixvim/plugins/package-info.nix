{ ... }:
{
  programs.nixvim = {
    plugins.package-info = {
      enable = true;
      enableTelescope = true;
    };

    keymaps = [
      {
        action = "+package-info";
        key = "<leader>p";
        mode = "n";
        options = {
          desc = "+Check NPM package-info";
        };
      }

      {
        action = "<Cmd>PackageInfoShowForce<CR>"; # force refetch package info
        key = "<leader>ps";
        mode = "n";
        options = {
          desc = "package-info: run `npm outdated --json`";
        };
      }
      {
        action = "<Cmd>PackageInfoChangeVersion<CR>";
        key = "<leader>pv";
        mode = "n";
        options = {
          desc = "package-info: version picker";
        };
      }
    ];
  };
}
