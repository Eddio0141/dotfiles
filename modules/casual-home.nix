{ pkgs, inputs, system, ... }:
{
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
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
        obs-vkcapture
      ];
    };
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
    set clipboard=unnamedplus
    set smartcase 
    set ignorecase

    let mapleader = " "

    Plug 'machakann/vim-highlightedyank'

    nmap <S-H> <Action>(PreviousTab)
    nmap <S-L> <Action>(NextTab)
    nmap <leader>bd <Action>(CloseContent)
    nmap <leader>bo <Action>(CloseAllEditorsButActive)

    nmap <leader>ca <Action>(ShowIntentionActions)
    nmap <leader>cr <Action>(RenameElement)

    nmap <leader><space> <Action>(GotoFile)
    nmap <leader>/ <Action>(FindInPath)

    nmap gI <Action>(GotoImplementation)
    nmap gr <Action>(GotoDeclaration)

    imap <C-Space> <Action>(EditorChooseLookupItem)

    nmap gcc <Action>(CommentByLineComment)
    vmap gc <Action>(CommentByLineComment)
    nmap <leader>gg <Action>(ActivateCommitToolWindow)
    nmap <leader>e <Action>(ActivateProjectToolWindow)

    inoremap <c-s> <esc> \| <Action>(ReformatCode) \| :w<cr>
  '';
}

