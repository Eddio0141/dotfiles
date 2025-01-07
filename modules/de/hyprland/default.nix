{
  config,
  lib,
  pkgs,
  username,
  inputs,
  system,
  ...
}:
with lib;
let
  cfg = config.yuu.de.hyprland;
  xdg-desktop-portal-termfilechooser =
    inputs.nixpkgs-termfilechooser.legacyPackages.x86_64-linux.xdg-desktop-portal-termfilechooser.overrideAttrs
      {
        src = pkgs.fetchFromGitHub {
          owner = "boydaihungst";
          repo = "xdg-desktop-portal-termfilechooser";
          rev = "a0b20c06e3d45cf57218c03fce1111671a617312";
          hash = "sha256-MOS2dS2PeH5O0FKxZfcJUAmCViOngXHZCyjRmwAqzqE=";
        };
        patches = [ ];
      };
in
{
  options.yuu.de.hyprland = {
    enable = mkEnableOption "hyprland";
    xwaylandScale = mkOption {
      type = types.int;
      default = 1;
      description = "Scaling factor for Xwayland applications";
    };
    brightness-change = mkEnableOption "monitor brightness adjustment";
    monitors = mkOption {
      # TODO: make this a proper structure
      type = types.listOf types.str;
      default = [ ];
      description = "List of monitors to be added";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # cachix for hyprland
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      programs = {
        hyprland = {
          enable = true;
          # package = inputs.hyprland.packages.${system}.hyprland;
          # portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
          withUWSM = true;
        };
        uwsm.enable = true;
      };

      environment.systemPackages = with pkgs; [
        pavucontrol
        xdg-desktop-portal-termfilechooser
        ### wallpaper
        inputs.swww.packages.${system}.swww
        waypaper
        ###
      ];

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time";
            user = "greeter";
          };
        };
      };

      yuu = {
        programs = {
          waybar.enable = true;
          kitty.enable = true;
        };
        security.polkit-gnome.enable = true;
      };

      home-manager.users.${username} = {
        programs = {
          wlogout.enable = true;
          hyprlock.enable = true;
        };

        services = {
          hypridle = {
            enable = true;
            settings = {
              general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on";
              };
            };
          };
          dunst.enable = true;
        };

        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false; # use uwsm
          xwayland.enable = true;
          # if variable or colours, quote them
          settings = mkMerge [
            ((import ./config) { inherit pkgs cfg lib; })
            (mkIf cfg.brightness-change (import ./config/brightness.nix { inherit pkgs; }))
          ];
        };

        xdg.configFile = {
          "xdg-desktop-portal/hyprland-portals.conf" = {
            enable = true;
            text = ''
              [preferred]
              default = hyprland;gtk
              org.freedesktop.impl.portal.FileChooser = termfilechooser
            '';
          };
          "xdg-desktop-portal-termfilechooser/config" = {
            enable = true;
            text = ''
              [filechooser]
              cmd=${xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
              default_dir=$HOME
            '';
          };
        };
      };
    })
    (import ./hyprlock.nix { inherit username lib; })
  ];
}
