{ config, pkgs, username, inputs, ... }:
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "daily";
  };

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
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # plugins = [];
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
    systemdIntegration = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };
}
