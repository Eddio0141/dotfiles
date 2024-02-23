{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.pack.comfy-shell;
in {
  options.yuu.pack.comfy-shell.enable = mkEnableOption "shell environment";

  config = (mkIf cfg.enable {
    # zsh setups
    users.users.${username}.shell = pkgs.zsh;

    programs.zsh.enable = true;

    users.defaultUserShell = pkgs.zsh;

    environment.shells = [ pkgs.zsh ];

    # fhs environment
    # https://nixos.org/manual/nixpkgs/unstable/#sec-fhs-environments
    environment.systemPackages = with pkgs; [
      (buildFHSEnv (
        appimageTools.defaultFhsEnvArgs //
      {
        name = "fhs-env";
        multiArch = true;
        runScript = "zsh";
      }))

      neofetch
    ];

    home-manager.users.${username} = {
      # neofetch art
      # TODO: move to local location
      xdg.configFile."neofetch/ascii-anime".source = ../../../config/neofetch/ascii-anime;

      # direnv
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      # zsh
      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        
        shellAliases = {
          update = "sudo nixos-rebuild switch --flake '.'";
          update-test = "sudo nixos-rebuild test --flake '.'";
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
    };
  });
}
