{
  pkgs,
  ...
}:
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
    iconTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze-dark";
    };
  };

  programs.home-manager.enable = true;

  programs = {
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
    eww = {
      enable = true;
      # TODO: enableNushellIntegration = true;
      configDir = ./eww;
    };
  };

  # mangohud
  programs.mangohud = {
    enable = true;
    settings = {
      position = "top-right";
    };
  };

  xdg.configFile = {
    "xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
    '';
    "xdg-desktop-portal/portals.conf".text = ''
      [preferred]
      default = gnome;gtk;
      org.freedesktop.impl.portal.FileChooser = termfilechooser
    '';
    "qt5ct/qt5ct.conf".source = ../config/qt5ct/qt5ct.conf;
    "qt5ct/colors/Dracula.conf".source =
      pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "qt5";
        rev = "master";
        sha256 = "tfUjAb+edbJ+5qar4IxWr4h3Si6MIwnbCrwI2ZdUFAM=";
      }
      + "/Dracula.conf";
  };

  xdg.dataFile."fonts".source = ../share/fonts;

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
