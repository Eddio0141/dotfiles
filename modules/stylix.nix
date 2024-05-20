{ pkgs, ... }:
{
  stylix = {
    image = ../assets/wallpaper/frieren.png;
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 24;
    };
    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = (pkgs.nerdfonts.override {
          fonts = [ "JetBrainsMono" ];
        });
      };
    };
  };
}
