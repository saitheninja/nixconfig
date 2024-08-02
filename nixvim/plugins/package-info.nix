{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      package-info-nvim # npm package info
    ];

    extraConfigLua = # lua
      ''
        require("package-info").setup();
      '';

    keymaps = [
      {
        action = "<Cmd>lua require('package-info').show({ force = true })<CR>"; # force refetch every time
        key = "<leader>ps";
        mode = "n";
        options = {
          desc = "Package Info: run `npm outdated --json`";
        };
      }
      {
        action = "<Cmd>lua require('package-info').change_version()<CR>"; # force refetch every time
        key = "<leader>pv";
        mode = "n";
        options = {
          desc = "Package Info: change version";
        };
      }
    ];
  };
}
