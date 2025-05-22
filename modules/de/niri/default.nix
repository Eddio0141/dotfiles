{
  config,
  lib,
  username,
  pkgs,
  inputs,
  link,
  ...
}:
let
  cfg = config.yuu.de.niri;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;
in
{
  options.yuu.de.niri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable {
    programs = {
      niri = {
        enable = true;
        package = (
          pkgs.niri-unstable.overrideAttrs {
            version = "25.05";
            src = pkgs.fetchFromGitHub {
              owner = "yalter";
              repo = "niri";
              rev = "v25.05";
              hash = "sha256-ngQ+iTHmBJkEbsjYfCWTJdV8gHhOCTkV8K0at6Y+YHI=";
            };
          }
        );
      };
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite-unstable
      inputs.swww.packages.${system}.swww
      waypaper
      brightnessctl
    ];

    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
    ];

    nixpkgs.overlays = [
      inputs.niri.overlays.niri
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

    yuu.programs = {
      waybar.enable = true;
      kitty.enable = true;
      dunst.enable = true;
      wofi.enable = true;
      hyprlock.enable = true;
    };

    home-manager.users.${username} = {
      xdg.configFile."niri/config.kdl".source = link ./config.kdl;

      programs = {
        niri.config = null;
        wlogout = {
          enable = true;
          layout = [
            {
              label = "lock";
              action = "loginctl lock-session";
              text = "Lock";
              keybind = "l";
            }
            {
              label = "hibernate";
              action = "systemctl suspend-then-hibernate";
              text = "Hibernate";
              keybind = "h";
            }
            {
              label = "logout";
              action = "loginctl terminate-user $USER";
              text = "Logout";
              keybind = "e";
            }
            {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
            }
            {
              label = "suspend";
              action = "systemctl suspend";
              text = "Suspend";
              keybind = "u";
            }
            {
              label = "reboot";
              action = "systemctl reboot";
              text = "Reboot";
              keybind = "r";
            }
          ];
        };
        waybar.settings.mainBar = {
          modules-left = [ "niri/workspaces" ];
          modules-center = [ "niri/window" ];
        };
      };
    };
  };
}
