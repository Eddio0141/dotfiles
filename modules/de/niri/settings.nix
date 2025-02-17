actions:
let
  radius = 15.;
  window-geo = {
    top-left = radius;
    top-right = 0.0;
    bottom-left = 0.0;
    bottom-right = radius;
  };
in
{
  prefer-no-csd = true;
  input = {
    touchpad = {
      natural-scroll = false;
      accel-profile = "flat";
      accel-speed = 0.5;
    };
    mouse = {
      accel-profile = "flat";
      accel-speed = -0.35;
    };
    keyboard.xkb.options = "caps:escape";
  };
  layout = {
    preset-column-widths = [
      { proportion = 1. / 4.; }
      { proportion = 1. / 2.; }
      { proportion = 3. / 4.; }
      { proportion = 0.9 / 1.; }
    ];
    preset-window-heights = [
      { proportion = 1. / 4.; }
      { proportion = 1. / 2.; }
      { proportion = 3. / 4.; }
    ];
    default-column-width = {
      proportion = 0.9 / 1.;
    };
    border = {
      active.gradient = {
        angle = 5;
        relative-to = "workspace-view";
        from = "rgb(59,28,100)";
        in' = "srgb-linear";
        to = "rgb(235,205,235)";
      };
      inactive.color = "rgb(12,0,22)";
    };
  };
  spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ "waybar" ]; }
    { command = [ "swww-daemon" ]; }
    {
      command = [
        "waypaper"
        "--restore"
      ];
    }
  ];
  environment = {
    DISPLAY = ":0";
    NIXOS_OZONE_WL = "1";
    GDK_DEBUG = "portals";
    # xwayland-satellite fix for java apps
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_IM_MODULE = "fcitx";
    # # Fixes IM on some application, don't use GTK_IM_MODULE="xim" because it breaks wayland apps IM
    # environment.variables = {
    #     # Only for QT 6.7+, which, by the virtue of using KDE plasma 6, I have
    #     QT_IM_MODULES="wayland;fcitx;ibus";
    # };
  };
  window-rules = [
    # global
    {
      geometry-corner-radius = window-geo;
      clip-to-geometry = true;
    }

    # unity
    {
      matches = [
        {
          title = "^Unity$";
          app-id = "^Unity$";
        }
      ];
      open-focused = false;
    }

    # firefox
    {
      matches = [
        {
          title = "^Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox$";
          app-id = "^firefox$";
        }
      ];
      open-floating = true;
    }

    # ghidra
    {
      matches = [
        {
          title = "^Version Tracking Wizard$";
          app-id = "^ghidra-Ghidra$";
        }
      ];
      max-height = 900;
      max-width = 600;
    }
    {
      # shrink and don't focus oversized popups
      matches = [
        {
          title = "^Merge Version Tracking Session$";
          app-id = "^ghidra-Ghidra$";
        }
        {
          title = "^Loading Associations$";
          app-id = "^ghidra-Ghidra$";
        }
      ];
      max-height = 300;
      max-width = 500;
      open-focused = false;
    }
    {
      # popups that should float
      matches = [
        {
          title = "^win\\d+$";
          app-id = "^ghidra-Ghidra$";
        }
        {
          title = "^Opening VT Session$";
          app-id = "^ghidra-Ghidra$";
        }
        {
          title = "^Choose a \\d+ program$";
          app-id = "^ghidra-Ghidra$";
        }
        {
          title = "^Confirm Delete$";
          app-id = "^ghidra-Ghidra$";
        }
        {
          title = "^Save Program$";
          app-id = "^ghidra-Ghidra$";
        }
        {
          title = "^Rename Local Variable$";
          app-id = "^ghidra-Ghidra$";
        }
      ];
      open-floating = true;
      open-focused = false;
    }
  ];
  # TODO: wait for next niri release
  layer-rules = [
    #   {
    #     matches = [
    #       {
    #         namespace = "^wofi$";
    #       }
    #     ];
    #     geometry-corner-radius = window-geo;
    #   }
    {
      matches = [ { namespace = "^waybar$"; } ];
      opacity = 0.85;
    }
  ];
  binds =
    with actions;
    let
      sh = spawn "sh" "-c";
    in
    {
      "Mod+Q".action = spawn "kitty";
      "Mod+S".action = sh ''pidof wofi || wofi'';
      "Mod+E".action = spawn "kitty" "yazi";

      "Mod+W".action = close-window;
      "Mod+T".action = toggle-window-floating;
      "Mod+R".action = switch-focus-between-floating-and-tiling;
      "Mod+F".action = fullscreen-window;

      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+K".action = focus-window-or-workspace-up;
      "Mod+J".action = focus-window-or-workspace-down;
      "Mod+WheelScrollDown".action = focus-workspace-down;
      "Mod+WheelScrollUp".action = focus-workspace-up;
      "Mod+WheelScrollRight".action = focus-column-right;
      "Mod+WheelScrollLeft".action = focus-column-left;
      "Mod+Comma".action = focus-monitor-left;
      "Mod+Period".action = focus-monitor-right;

      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+L".action = move-column-right;
      "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
      "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
      "Mod+Shift+M".action = consume-or-expel-window-right;
      "Mod+Shift+N".action = consume-or-expel-window-left;
      "Mod+Shift+Comma".action = move-window-to-monitor-left;
      "Mod+Shift+Period".action = move-window-to-monitor-right;

      "Mod+Shift+bracketright".action = switch-preset-window-width;
      "Mod+Shift+bracketleft".action = switch-preset-window-height;
      "Mod+Shift+P".action = maximize-column;
      "Mod+Shift+O".action = reset-window-height;

      "Print".action = screenshot-screen;
      "Ctrl+Print".action = screenshot;

      "Shift+Alt+P".action = spawn "playerctl" "play-pause";
      "Shift+Alt+O".action = spawn "playerctl" "next";
      "Shift+Alt+I".action = spawn "playerctl" "previous";

      "Ctrl+Alt+Delete".action = sh ''pidof wlogout || wlogout'';
      # waiting for https://github.com/YaLTeR/niri/issues/119 to be resolved, have to do this or screen goes red
      "Mod+Shift+BackSpace".action =
        sh ''pidof hyprlock || niri msg action do-screen-transition --delay-ms 300 && hyprlock'';
    };
}
