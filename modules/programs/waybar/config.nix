{
  mainBar = {
    # margin-top = 8;
    layer = "top";
    position = "top";
    height = 30;
    spacing = 4;
    # TODO: hyprland, sway
    modules-left =   [ "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    # modules-left = [ "sway/workspaces" ];
    # modules-center = [ "sway/window" ];
    modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "clock" "tray" ];

    # Modules configuration
    "pulseaudio" = {
      "format" = "{volume}% {icon}";
      "format-icons" = {
        "default" = [ "" "" "" ];
      };
    };
    "hyprland/window" = {
      "max-length" = 200;
      "separate-outputs" = true;
    };
    "tray" = {
      "spacing" = 10;
    };
    "clock" = {
      "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      "format-alt" = "{:%Y-%m-%d %a}";
      "format" = "{:%H:%M:%S}";
      "interval" = 1;
      "calendar" = {
        "mode" = "month";
        "mode-mon-col" = 3;
        "on-scroll" = 1;
        "on-click-right" = "mode";
        "format" = {
          "months" = "<span color='#ffead3'><b>{}</b></span>";
          "days" = "<span color='#ecc6d9'><b>{}</b></span>";
          "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
          "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
          "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
        };
      };
      "actions" = {
        "on-click-right" = "mode";
        "on-click-forward" = "tz_up";
        "on-click-backward" = "tz_down";
        "on-scroll-up" = "shift_up";
        "on-scroll-down" = "shift_down";
      };
    };
    "cpu" = {
      "format" = "{usage}% ";
      interval = 1;
      "tooltip" = false;
    };
    "memory" = {
      "format" = "{}% ";
      interval = 1;
    };
    "temperature" = {
      "critical-threshold" = 80;
      "format" = "{temperatureC}°C {icon}";
      "format-icons" = [ "" "" "" ];
      interval = 1;
    };
  };
}

