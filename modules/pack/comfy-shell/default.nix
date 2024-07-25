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
          # fe aka fhs-env
          name = "fe";
          multiArch = true;
          runScript = "zsh";
          profile = ''
            export DOTNET_ROOT="${pkgs.dotnet-runtime}"
          '';
          targetPkgs = pkgs: (with pkgs; [
            icu.dev
            dotnet-runtime
            libGLU.dev

            # this comes from unityhub package
            ##########
            # Unity Hub binary dependencies
            xorg.libXrandr
            xdg-utils

            # GTK filepicker
            gsettings-desktop-schemas
            hicolor-icon-theme

            # Bug Reporter dependencies
            fontconfig
            freetype
            lsb-release
            ##########
          ]);
          multiPkgs = pkgs: (with pkgs; [
            # also from unityhub pacakge
            ##########
            # Unity Hub ldd dependencies
            cups
            gtk3
            expat
            libxkbcommon
            lttng-ust_2_12
            krb5
            alsa-lib
            nss
            libdrm
            mesa
            nspr
            atk
            dbus
            at-spi2-core
            pango
            xorg.libXcomposite
            xorg.libXext
            xorg.libXdamage
            xorg.libXfixes
            xorg.libxcb
            xorg.libxshmfence
            xorg.libXScrnSaver
            xorg.libXtst

            # Unity Hub additional dependencies
            libva
            openssl
            cairo
            libnotify
            libuuid
            libsecret
            udev
            libappindicator
            wayland
            cpio
            icu
            libpulseaudio

            # Unity Editor dependencies
            libglvnd # provides ligbl
            xorg.libX11
            xorg.libXcursor
            glib
            gdk-pixbuf
            libxml2
            zlib
            clang
            git # for git-based packages in unity package manager

            # Unity Editor 2019 specific dependencies
            xorg.libXi
            xorg.libXrender
            gnome2.GConf
            libcap
            ##########
          ]);
        }
      ))
      (buildFHSEnv (
        appimageTools.defaultFhsEnvArgs //
        unityhub.fhsEnv //
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
