{
  config,
  lib,
  pkgs,
  username,
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

      programs.hyprland = {
        enable = true;
        # package = inputs.hyprland.packages.${system}.default;
        # portalPackage = inputs.xdph.packages.${system}.default;
      };

      environment.systemPackages = with pkgs; [
        pavucontrol
        sddm-chili-theme # idk why but it has to be here
      ];

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "${pkgs.sddm-chili-theme}/share/sddm/themes/chili";
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
          systemd.enable = true;
          xwayland.enable = true;
          # if variable or colours, quote them
          settings = mkMerge [
            ((import ./config) { inherit pkgs cfg lib; })
            (mkIf cfg.brightness-change (import ./config/brightness.nix { inherit pkgs; }))
          ];
        };
      };
    })
    (import ./hyprlock.nix { inherit username; })
  ];
}
