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
  };

  config = mkIf cfg.enable {
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
      # wallpaper
      inputs.swww.packages.${system}.swww
      waypaper
      # screenshot
      inputs.hyprpicker.packages.${system}.default
      inputs.hyprcontrib.packages.${system}.grimblast
    ];

    yuu = {
      programs = {
        waybar.enable = true;
        kitty.enable = true;
        dunst.enable = true;
      };
      security.polkit-gnome.enable = true;
    };

    home-manager.users.${username} = {
      programs = {
        wlogout.enable = true;
        hyprlock.enable = true;
        waybar.settings.mainBar = {
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
        };
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
      };

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false; # use uwsm
        package = null;
        portalPackage = null;
        xwayland.enable = true;
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
      };
    };
  };
}
