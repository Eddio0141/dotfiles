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

  xdg.configFile."neofetch/ascii-anime" = {
    source = ./config/neofetch/ascii-anime;
  };

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
      theme = "random";
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
    style = ./config/waybar/style.css;
    settings = import ./config/waybar/config;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # plugins = [];
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
    systemdIntegration = true;
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
}
