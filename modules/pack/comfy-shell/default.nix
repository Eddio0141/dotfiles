{ config, lib, pkgs, username, ... }:
with lib;
let
  cfg = config.yuu.pack.comfy-shell;
in
{
  options.yuu.pack.comfy-shell.enable = mkEnableOption "shell environment";

  config = (mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tldr
    ];

    # zsh setups
    users.users.${username}.shell = pkgs.zsh;

    programs = {
      zsh.enable = true;
      nix-index.enable = true;
      nh = {
        enable = true;
        flake = "/home/${username}/dotfiles";
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 31d";
        };
      };
    };

    users.defaultUserShell = pkgs.zsh;

    environment.shells = [ pkgs.zsh ];

    home-manager.users.${username} = {
      programs = {
        nix-index = {
          enable = true;
          enableZshIntegration = true;
        };

        # direnv
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };

        # zsh
        zsh = {
          enable = true;
          autosuggestion.enable = true;
          enableCompletion = true;
          syntaxHighlighting.enable = true;

          shellAliases = {
            update = "nh os switch";
            update-test = "nh os test";
            upgrade = "nh os switch -u";
          };

          # oh my zsh
          oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "fino-time";
          };

          initExtra = ''
            
            if [[ $- = *i* ]]; then
            fastfetch

            echo "Welcome back $USER!"
            fi
          '';

          plugins = [
            {
              name = "vi-mode";
              src = pkgs.zsh-vi-mode;
              file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
            }
          ];
        };
      };
    };

    yuu.programs.fastfetch.enable = true;
  });
}
