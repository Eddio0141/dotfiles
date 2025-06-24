{
  config,
  lib,
  pkgs,
  username,
  link,
  inputs,
  system,
  ...
}:
with lib;
let
  cfg = config.yuu.pack.comfy-shell;
  defaultShell = pkgs.nushell;
in
# fhs-env = (
#   buildFHSEnv (
#     appimageTools.defaultFhsEnvArgs
#     // {
#       # fe aka fhs-env
#       name = "fe";
#       multiArch = true;
#       runScript = "nu";
#       profile = ''
#         export DOTNET_ROOT="${pkgs.dotnet-runtime}"
#       '';
#       targetPkgs =
#         pkgs:
#         (with pkgs; [
#           icu.dev
#           dotnet-runtime
#           libGLU.dev
#
#           # this comes from unityhub package
#           ##########
#           # Unity Hub binary dependencies
#           xorg.libXrandr
#           xdg-utils
#
#           # GTK filepicker
#           gsettings-desktop-schemas
#           hicolor-icon-theme
#
#           # Bug Reporter dependencies
#           fontconfig
#           freetype
#           lsb-release
#           ##########
#         ]);
#       multiPkgs =
#         pkgs:
#         (with pkgs; [
#           # also from unityhub pacakge
#           ##########
#           # Unity Hub ldd dependencies
#           cups
#           gtk3
#           expat
#           libxkbcommon
#           lttng-ust_2_12
#           krb5
#           alsa-lib
#           nss
#           libdrm
#           mesa
#           nspr
#           atk
#           dbus
#           at-spi2-core
#           pango
#           xorg.libXcomposite
#           xorg.libXext
#           xorg.libXdamage
#           xorg.libXfixes
#           xorg.libxcb
#           xorg.libxshmfence
#           xorg.libXScrnSaver
#           xorg.libXtst
#
#           # Unity Hub additional dependencies
#           libva
#           openssl
#           cairo
#           libnotify
#           libuuid
#           libsecret
#           udev
#           libappindicator
#           wayland
#           cpio
#           icu
#           libpulseaudio
#
#           # Unity Editor dependencies
#           libglvnd # provides ligbl
#           xorg.libX11
#           xorg.libXcursor
#           glib
#           gdk-pixbuf
#           libxml2
#           zlib
#           clang
#           git # for git-based packages in unity package manager
#
#           # Unity Editor 2019 specific dependencies
#           xorg.libXi
#           xorg.libXrender
#           gnome2.GConf
#           libcap
#           ##########
#
#           # run half life native
#           libvorbis
#           SDL
#           SDL2
#           fontconfig
#           freetype
#           openal
#           gtk2
#           libpng12
#           libgpg-error
#           (stdenv.mkDerivation {
#             name = "libgcrypt-11";
#             src = ./libgcrypt.so.11.8.2;
#
#             dontUnpack = true;
#             dontBuild = true;
#             dontStrip = true;
#
#             installPhase = ''
#               mkdir -p $out/lib
#               cp $src $out/lib/libgcrypt.so.11
#
#               chmod +x $out/lib/libgcrypt.so.11
#             '';
#           })
#         ]);
#     }
#   )
# );
{
  options.yuu.pack.comfy-shell.enable = mkEnableOption "shell environment";

  config = (
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        tealdeer
        tokei
        trash-cli
        ouch
        nushell
        fish # for nushell completions
        carapace
        # fhs-env
        devenv
        devbox
      ];

      # nushell setups
      users.users.${username}.shell = defaultShell;

      programs = {
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

      users.defaultUserShell = defaultShell;

      environment.shells = [ defaultShell ];

      home-manager.users.${username} = {
        imports = [ ./yazi ];

        programs = {
          nix-index = {
            enable = true;
            # TODO: this doesn't exist for nix-index: enableNushellIntegration = true;
            package = inputs.nix-index.packages.${system}.default;
          };

          # direnv
          direnv = {
            enable = true;
            enableNushellIntegration = true;
            nix-direnv.enable = true;
          };

          oh-my-posh = {
            enable = true;
            enableNushellIntegration = true;
          };

          fd.enable = true;

          zoxide = {
            enable = true;
            enableNushellIntegration = true;
          };
        };

        xdg.configFile = {
          "nushell/config.nu".source = link ./config.nu;
          "nushell/env.nu".source = link ./env.nu;
          "nushell/nu_scripts".source = inputs.nu-scripts;
          # TODO: restore to pkgs at some point
          # "nushell/command-not-found.nu".source = "${pkgs.nix-index}/etc/profile.d/command-not-found.nu";
          "nushell/command-not-found.nu".source = "${
            inputs.nix-index.packages.${system}.default
          }/etc/profile.d/command-not-found.nu";
        };
      };

      yuu.programs.fastfetch.enable = true;
    }
  );
}
