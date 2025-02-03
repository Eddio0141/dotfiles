actions: {
  prefer-no-csd = true;
  input = {
    touchpad = {
      natural-scroll = false;
      accel-profile = "flat";
      accel-speed = 0.5;
    };
    keyboard.xkb.options = "caps:escape";
  };
  layout = {
    preset-column-widths = [
      { proportion = 1. / 4.; }
      { proportion = 1. / 2.; }
      { proportion = 3. / 4.; }
    ];
    preset-window-heights = [
      { proportion = 1. / 4.; }
      { proportion = 1. / 2.; }
      { proportion = 3. / 4.; }
    ];
    default-column-width = { };
    border.active = {
      color = "rgb(255 255 255)";
    };
  };
  binds =
    with actions;
    let
      sh = spawn "sh" "-c";
    in
    {
      "Mod+Q".action = spawn "kitty";
      "Mod+S".action = sh ''pidof wofi || wofi --show drun -I -m -i -W 30% -H 75%'';
      "Mod+E".action = spawn "kitty" "yazi";

      "Mod+W".action = close-window;

      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+K".action = focus-workspace-up;
      "Mod+J".action = focus-workspace-down;
      "Mod+WheelScrollDown".action = focus-workspace-down;
      "Mod+WheelScrollUp".action = focus-workspace-up;
      "Mod+WheelScrollRight".action = focus-column-right;
      "Mod+WheelScrollLeft".action = focus-column-left;

      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+L".action = move-column-right;
      "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
      "Mod+Shift+K".action = move-window-up-or-to-workspace-up;

      "Mod+Shift+bracketright".action = switch-preset-window-width;
      "Mod+Shift+bracketleft".action = switch-preset-window-height;
      "Mod+Shift+P".action = maximize-column;
      "Mod+Shift+O".action = reset-window-height;
      # "Mod+Shift+P".action = set-column-width "+25%";
      # "Mod+Shift+O".action = set-column-width "-25%";

      "Mod+Shift+F".action = fullscreen-window;

      "Shift+Alt+P".action = spawn "playerctl" "play-pause";
      "Shift+Alt+O".action = spawn "playerctl" "next";
      "Shift+Alt+I".action = spawn "playerctl" "previous";
    };
  spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ "waybar" ]; }
  ];
  environment = {
    DISPLAY = ":0";
    NIXOS_OZONE_WL = "1";
  };
}
