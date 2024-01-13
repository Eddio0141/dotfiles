{ config, pkgs, username, inputs, system, ... }:
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
    
    extraConfig = {
      init.defaultBranch = "main";
      advice.addIgnoredFile = "false";
      pull.rebase = "false";
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.input-overlay
    ];
  };

  xdg.configFile."neofetch/ascii-anime".source = ./config/neofetch/ascii-anime;

  # zsh
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake '.#desktop'";
      update-test = "sudo nixos-rebuild test --flake '.#desktop'";
      upgrade = "nix flake update";
      neofetch = "neofetch --source ~/.config/neofetch/ascii-anime";
    };

    # oh my zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "fino-time";
    };

    initExtra = ''
if [[ $- = *i* ]]; then
  neofetch --source ~/.config/neofetch/ascii-anime

  echo "Welcome back $USER!"
fi
'';
  };

  programs.wofi = {
    enable = true;
    style = builtins.readFile ./config/wofi/style.css;
  };

  # TODO waybar is only when hyprland is enabled
  programs.waybar = {
    enable = true;
    # TODO wait for this fix
    package = inputs.waybar.packages.${system}.waybar.override (prev: {
      waybar = prev.waybar.override {
        catch2_3 = pkgs.catch2.overrideAttrs {
          src = pkgs.fetchFromGitHub {
            owner = "catchorg";
            repo = "Catch2";
            rev = "v3.5.1";
            hash = "sha256-OyYNUfnu6h1+MfCF8O+awQ4Usad0qrdCtdZhYgOY+Vw=";
          };
        };
      };
    });
    style = ./config/waybar/style.css;
    settings = import ./config/waybar/config;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # plugins = [];
    settings = {};
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
    systemd.enable = true;
    xwayland.enable = true;
  };

  # mangohud
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      position = "top-right";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."qt5ct/qt5ct.conf".source = ./config/qt5ct/qt5ct.conf;

  xdg.configFile."qt5ct/colors/Dracula.conf".source = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "qt5";
    rev = "master";
    sha256 = "tfUjAb+edbJ+5qar4IxWr4h3Si6MIwnbCrwI2ZdUFAM=";
  } + "/Dracula.conf";

  xdg.dataFile."fonts".source = ./share/fonts;

  # hyprpaper
  xdg.configFile."hypr/hyprpaper.conf".source = ./config/hypr/hyprpaper.conf;

  # TODO add dolphin settings

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vadimcn.vscode-lldb
      serayuzgur.crates
      mkhl.direnv
      ms-azuretools.vscode-docker
      usernamehw.errorlens
      github.copilot
      github.copilot-chat
      wmaurer.change-case
      ms-ceintl.vscode-language-pack-ja
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-slideshow
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      ms-python.vscode-pylance
      ms-python.python
      mechatroner.rainbow-csv
      rust-lang.rust-analyzer
      foxundermoon.shell-format
      wakatime.vscode-wakatime
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      { name = "discord-vscode"; publisher = "icrawl"; version = "5.8.0"; sha256 = "IU/looiu6tluAp8u6MeSNCd7B8SSMZ6CEZ64mMsTNmU="; }
      { name = "feather-vscode"; publisher = "melishev"; version = "1.0.1"; sha256 = "sFgNgNAFlTfx6m+Rp5lQxWnjSe7LLzB6N/gq7jQhRJs="; }
      { name = "cosmicsarthak-neon-theme"; publisher = "cosmicsarthak"; version = "4.4.7"; sha256 = "/vuogor5TMuBY8z9tJsd0PZAoPixgCYJsEfxHA14I/Q="; }
      { name = "theme-pink-cat-boo"; publisher = "ftsamoyed"; version = "1.3.0"; sha256 = "FD7fim0sRWAADzDAbhV3dnYW3mxoSgVPLs5Wkg5r01k="; }
      { name = "vscode-rhai"; publisher = "rhaiscript"; version = "0.6.6"; sha256 = "Yw+wq67u55Hr0Kan/3RrG8Rf6F2pU2FvkD30i4S3paE="; }
      { name = "vscode-todo-highlight"; publisher = "wayou"; version = "1.0.5"; sha256 = "CQVtMdt/fZcNIbH/KybJixnLqCsz5iF1U0k+GfL65Ok="; }
      { name = "toml"; publisher = "be5invis"; version = "0.6.0"; sha256 = "yk7buEyQIw6aiUizAm+sgalWxUibIuP9crhyBaOjC2E="; }
      { name = "vscode-counter"; publisher = "uctakeoff"; version = "3.4.0"; sha256 = "4kdcq+a366PA1Lh2kwx37qV6YxWvqzmUVByRxpvul9g="; }
    ];
  };
}
