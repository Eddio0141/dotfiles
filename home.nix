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
    systemd.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # plugins = [];
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
}
