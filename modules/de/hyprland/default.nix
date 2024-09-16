{
  config,
  lib,
  pkgs,
  inputs,
  system,
  home-manager,
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

  config = (
    mkIf cfg.enable {
      # cachix for hyprland
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${system}.default;
        portalPackage = inputs.xdph.packages.${system}.default;
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

      # obviously for hyprlock
      security.pam.services.hyprlock = { };

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

        # TODO: image to this repo
        # TODO: home manager has this option
        xdg.configFile."hypr/hyprlock.conf".text = ''
          background {
            path = /home/yuu/Pictures/wallpaper/frieren.png
            blur_passes = 1
            blur_size = 1
          }
          input-field {
            size = 350, 50
            outline_thickness = 1
            dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = false
            dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
            outer_color = rgb(151515)
            inner_color = rgb(200, 200, 200)
            font_color = rgb(10, 10, 10)
            fade_on_empty = true
            fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
            placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
            hide_input = false
            rounding = -1 # -1 means complete rounding (circle/oval)
            check_color = rgb(204, 136, 34)
            fail_color = rgb(204, 34, 34) # if authentication failed, changes outer_color and fail message color
            fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
            fail_transition = 300 # transition time in ms between normal outer_color and fail_color
            capslock_color = -1
            numlock_color = -1
            bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
            invert_numlock = false # change color if numlock is off
            swap_font_color = false # see below

            position = 0, -20
            halign = center
            valign = center
          }
          label {
            text = $TIME
            text_align = center
            font_color = rgb(200, 200, 200)
            font_size = 25
            font_family = Noto Sans
            position = 0, 80
            halign = center
            valign = center
          }
        '';
      };
    }
  );
}
