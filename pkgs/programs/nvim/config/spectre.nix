{ pkgs, ... }:
{
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      nvim-spectre
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>sr";
        action = ''function() require("spectre").open() end'';
        lua = true;
        options.desc = "Replace in files (Spectre)";
      }
    ];
  };
}
