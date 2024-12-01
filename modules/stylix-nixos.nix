{ pkgs, ... }:
{
  stylix = {
    enable = true;
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
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "DejaVuSansM Nerd Font";
        package = pkgs.nerd-fonts.dejavu-sans-mono;
      };
    };
  };
}
