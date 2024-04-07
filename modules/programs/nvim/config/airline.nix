{ pkgs, ... }:
{
  config = {
    plugins.airline = {
      enable = true;
      highlightingCache = true;
      powerlineFonts = true;
      theme = "solarized";
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-airline-themes
    ];

    globals = {
      airline_solarized_bg = "dark";
    };
  };
}
