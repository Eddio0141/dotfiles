{
  pkgs,
  lib,
  config,
  nixConfig,
  ...
}:
let
  link =
    path:
    config.lib.file.mkOutOfStoreSymlink (
      "${nixConfig.programs.nh.flake}/modules"
      + (builtins.substring 1 ((builtins.stringLength path) - 1) path)
    );
in
{
  imports = [
    ./stylix-hm.nix
  ];

  home = {
    stateVersion = "23.05";
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
    };
  };

  gtk = {
    enable = true;
    # theme = {
    #   package = pkgs.libsForQt5.breeze-gtk;
    #   name = "Breeze-Dark";
    # };
    iconTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze-dark";
    };
    # font = {
    #   name = "Noto Sans";
    #   size = 10;
    # };
  };

  programs.home-manager.enable = true;

  programs = {
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
    eww = {
      enable = true;
      enableZshIntegration = true;
      configDir = ./eww;
    };
  };

  programs.wofi = {
    enable = true;
    style = lib.mkForce (builtins.readFile ../config/wofi/style.css);
    settings = {
      width = "30%";
      height = "75%";
      insensitive = true;
      allow_markup = true;
      allow_images = true;
      show = "drun";
    };
  };

  # mangohud
  programs.mangohud = {
    enable = true;
    settings = {
      position = "top-right";
    };
  };

  xdg.configFile."qt5ct/qt5ct.conf".source = ../config/qt5ct/qt5ct.conf;

  xdg.configFile."qt5ct/colors/Dracula.conf".source =
    pkgs.fetchFromGitHub {
      owner = "dracula";
      repo = "qt5";
      rev = "master";
      sha256 = "tfUjAb+edbJ+5qar4IxWr4h3Si6MIwnbCrwI2ZdUFAM=";
    }
    + "/Dracula.conf";

  xdg.dataFile."fonts".source = ../share/fonts;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      awatcher = {
        package = pkgs.awatcher;
      };
      aw-watcher-steam = {
        package = pkgs.python3Packages.buildPythonApplication {
          pname = "aw-watcher-steam";
          version = "0.1.0";
          pyproject = true;
          src = pkgs.fetchFromGitHub {
            owner = "Edwardsoen";
            repo = "aw-watcher-steam";
            rev = "master";
            hash = "sha256-WTgu/3NrZyHXFMTAgp9SC3OeS/spThNBG2TFhiJDnno=";
          };
          nativeBuildInputs = with pkgs.python3Packages; [
            pkgs.poetry
            poetry-core
          ];
          dependencies = with pkgs.python3Packages; [
            aw-client
            requests
          ];
        };
        settings.aw-watcher-steam = {
          steam_id = "76561198289540452";
          # TODO api key needs to be hidden or something if i wanna make this public
          api_key = "3FA1BD7B6A76089A081DEE6A3E33C8C6";
        };
      };
    };
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  programs.ripgrep.enable = true;

  # for ideavim
  home.file.".ideavimrc".source = link "./ideavimrc.vim";

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "yazi-kitty.desktop" ];
      };
    };
    desktopEntries = {
      yazi-kitty = {
        name = "Yazi in Kitty";
        genericName = "File Manager";
        exec = "kitty yazi %f";
        terminal = false;
        categories = [
          "System"
          "FileTools"
          "FileManager"
        ];
        mimeType = [ "inode/directory" ];
      };
    };
  };
}
