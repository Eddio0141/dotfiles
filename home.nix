{ config, pkgs, username, ... }:
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.05";

    programs.git = {
      enable = true;
      userName = "Eddio0141";
      userEmail = "eddio0141@gmail.com";
    };

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.input-overlay
      ];
    };

  xdg.configFile."hypr" = {
    source = ./config/hypr;
    recursive = true;
    onChange = "${pkgs.hyprland}/bin/hyprctl reload";
  };

  xdg.configFile."neofetch/ascii-anime" = {
    source = ./config/neofetch/ascii-anime;
  };

  home.file.".zshrc" = {
    text = ''
[[ $- != *i* ]] && return

neofetch

echo "Welcome back $USER!"
'';
  };

  programs.wofi = {
    enable = true;
    style = builtins.readFile ./config/wofi/style.css;
  };

  programs.waybar = {
    enable = true;
    style = ./config/waybar/style.css;
    settings = import ./config/waybar/config;
    systemd.enable = true;
  };
}
