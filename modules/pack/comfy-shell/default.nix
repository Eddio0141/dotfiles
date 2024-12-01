{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib;
let
  cfg = config.yuu.pack.comfy-shell;
in
{
  options.yuu.pack.comfy-shell.enable = mkEnableOption "shell environment";

  config = (
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        tldr
        trash-cli
        ouch

        (buildFHSEnv (
          appimageTools.defaultFhsEnvArgs
          // {
            # fe aka fhs-env
            name = "fe";
            multiArch = true;
            runScript = "zsh";
            profile = ''
              export DOTNET_ROOT="${pkgs.dotnet-runtime}"
            '';
            targetPkgs =
              pkgs:
              (with pkgs; [
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
            multiPkgs =
              pkgs:
              (with pkgs; [
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

                # run half life native
                libvorbis
                SDL
                SDL2
                fontconfig
                freetype
                openal
                gtk2
                libpng12
                libgpg-error
                (stdenv.mkDerivation {
                  name = "libgcrypt-11";
                  src = ./libgcrypt.so.11.8.2;

                  dontUnpack = true;
                  dontBuild = true;
                  dontStrip = true;

                  installPhase = ''
                    mkdir -p $out/lib
                    cp $src $out/lib/libgcrypt.so.11

                    chmod +x $out/lib/libgcrypt.so.11
                  '';
                })
              ]);
          }
        ))
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
            # for umu-run
            sessionVariables = {
              GAMEID = "0";
            };

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
              function zvm_after_init() {
                bindkey '^ ' autosuggest-accept
              }

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

          fd.enable = true;

          yazi = {
            enable = true;
            enableZshIntegration = true;
            plugins = {
              ouch = pkgs.fetchFromGitHub {
                owner = "ndtoan96";
                repo = "ouch.yazi";
                rev = "main";
                hash = "sha256-fEfsHEddL7bg4z85UDppspVGlfUJIa7g11BwjHbufrE=";
              };
              restore = pkgs.fetchFromGitHub {
                owner = "boydaihungst";
                repo = "restore.yazi";
                rev = "master";
                hash = "sha256-yjjmy96tg10s+PSzPlL/BdyUUXwI0u+U00COrLwX8WI=";
              };
            };
            settings = {
              opener = {
                extract = [
                  {
                    run = "ouch d -y \"$@\"";
                    desc = "Extract here with ouch";
                    for = "unix";
                  }
                ];
              };
            };
            keymap = {
              manager.append_keymap = [
                {
                  on = [
                    "c"
                    "a"
                  ];
                  run = "plugin ouch --args=zip";
                  desc = "Archive selected files";
                }
                {
                  on = "u";
                  run = "plugin restore";
                  desc = "Restore last deleted files/folders";
                }
              ];
            };
          };
        };

        xdg.configFile = {
          # yazi extra stuff
          "yazi/theme.toml".source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/yazi/refs/heads/main/themes/macchiato/catppuccin-macchiato-pink.toml";
            hash = "sha256-+h8+QfUoYq7Un07GFnpg5f2ZeQORdhDpAgwX0iNDfnI=";
          };
          "yazi/init.lua".source = ./yazi/init.lua;
        };
      };

      yuu.programs.fastfetch.enable = true;
    }
  );
}
