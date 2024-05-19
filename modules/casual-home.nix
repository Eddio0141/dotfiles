{ config, pkgs, username, inputs, system, ... }:
{
  home = {
    stateVersion = "23.05";
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 24;
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

  programs = {
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
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

  # TODO bundle this in a module
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      awatcher = {
        package = inputs.nixpkgs-awatcher-temp.legacyPackages.${system}.awatcher;
      };
      aw-watcher-steam = {
        package = pkgs.python3Packages.buildPythonApplication {
          pname = "aw-watcher-steam";
          version = "0.1.0";
          pyproject = true;
          src = pkgs.fetchFromGitHub {
            owner = "Edwardsoen";
            repo = "aw-watcher-steam";
            rev = "13c4b65e3ea68b60112d359128272475cf69ce93";
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

  # TODO wait for hm to do something about this
  xdg.configFile."awatcher/config.toml".text = ''
  # The commented values are the defaults on the file creation
  [server]
  # port = 5600
  # host = "localhost"

  [awatcher]
  # idle-timeout-seconds=180
  # poll-time-idle-seconds=5
  # poll-time-window-seconds=1

  # Add as many filters as needed. The first matching filter stops the replacement.
  # There should be at least 1 match field, and at least 1 replace field.
  # Matches are case sensitive regular expressions between implici ^ and $, e.g.
  # - "." matches 1 any character
  # - ".*" matches any number of any characters
  # - ".+" matches 1 or more any characters.
  # - "word" is an exact match.
  # [[awatcher.filters]]
  # match-app-id = "navigator"
  # match-title = ".*Firefox.*"
  # replace-app-id = "firefox"
  # replace-title = "Unknown"

  # Use captures for app-id or title in the regular form to use parts of the original text
  # (parentheses for a capture, $1, $2 etc for each capture).
  # The example rule removes the changed file indicator from the title in Visual Studio Code:
  # "● file_config.rs - awatcher - Visual Studio Code" to "file_config.rs - awatcher - Visual Studio Code".
  # [[awatcher.filters]]
  # match-app-id = "code"
  # match-title = "● (.*)"
  # replace-title = "$1"
  '';

  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    XCURSOR_SIZE = "24";
  };

  programs.ripgrep.enable = true;

  xdg.configFile."nixpkgs/config.nix".text = ''
  {
    allowUnfree = true;
  }
  '';

  # for ideavim
  home.file.".ideavimrc".text = ''
  set relativenumber
  let mapleader = " "

  inoremap jk <Esc>

  nmap <S-H> <Action>(PreviousTab)
  nmap <S-L> <Action>(NextTab)
  nmap bd <Action>(CloseContent)

  nmap <leader>ca <Action>(ShowIntentionActions)

  nmap <leader><space> <Action>(GotoFile)
  nmap <leader>/ <Action>(FindInPath)

  nmap gI <Action>(GotoImplementation)

  imap <C-Space> <Action>(EditorChooseLookupItem)
  '';
}

