{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.pack.comfy-shell;
in
{
  options.yuu.pack.comfy-shell.enable = mkEnableOption "shell environment";

  config = (mkIf cfg.enable {
    # zsh setups
    users.users.${username}.shell = pkgs.zsh;

    programs = {
      zsh.enable = true;

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

    # fhs environment
    # https://nixos.org/manual/nixpkgs/unstable/#sec-fhs-environments
    environment.systemPackages = with pkgs; [
      (buildFHSEnv (
        appimageTools.defaultFhsEnvArgs //
        {
          name = "fhs-env";
          # multiArch = true;
          runScript = "zsh";
          profile = ''
            export DOTNET_ROOT="${pkgs.dotnet-runtime}"
          '';
          targetPkgs = pkgs: (with pkgs; [
            icu.dev
            dotnet-runtime
          ]);
        }
      ))
      (buildFHSEnv (
        appimageTools.defaultFhsEnvArgs //
        {
          name = "fhs-bepinex";
          runScript = "zsh";
          targetPkgs = pkgs: with pkgs; [
            file
          ];
        }
      ))
    ];

    home-manager.users.${username} = {
      programs = {
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
        };
      };
    };

    yuu.programs.fastfetch.enable = true;
  });
}
