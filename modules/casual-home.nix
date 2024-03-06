{ config, pkgs, username, ... }:
{
  home = {
    stateVersion = "23.05";
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 16;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "Breeze-Dark";
    };
    iconTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze-dark";
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
  };

  programs.home-manager.enable = true;

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "daily";
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.input-overlay
    ];
  };

  programs.wofi = {
    enable = true;
    style = builtins.readFile ../config/wofi/style.css;
  };

  # mangohud
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      position = "top-right";
    };
  };

  xdg.configFile."qt5ct/qt5ct.conf".source = ../config/qt5ct/qt5ct.conf;

  xdg.configFile."qt5ct/colors/Dracula.conf".source = pkgs.fetchFromGitHub
    {
      owner = "dracula";
      repo = "qt5";
      rev = "master";
      sha256 = "tfUjAb+edbJ+5qar4IxWr4h3Si6MIwnbCrwI2ZdUFAM=";
    } + "/Dracula.conf";

  xdg.dataFile."fonts".source = ../share/fonts;

  # hyprpaper
  xdg.configFile."hypr/hyprpaper.conf".source = ../config/hypr/hyprpaper.conf;

  # TODO add dolphin settings

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}

