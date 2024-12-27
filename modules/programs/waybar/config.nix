{
  mainBar = {
    # margin-top = 8;
    layer = "top";
    position = "top";
    height = 30;
    spacing = 4;
    # TODO: hyprland, sway
    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    # modules-left = [ "sway/workspaces" ];
    # modules-center = [ "sway/window" ];
    modules-right = [
      "cava"
      "pulseaudio"
      "cpu"
      "memory"
      "battery"
      "power-profiles-daemon"
      "clock"
      "tray"
    ];

    # Modules configuration
    power-profiles-daemon = {
      format = "{icon}";
      tooltip-format = "Power profile: {profile}\nDriver: {driver}";
      tooltip = true;
      format-icons = {
        default = " ";
        performance = " ";
        balanced = " ";
        power-saver = " ";
      };
    };
    cava = {
      framerate = 60;
      autosens = 1;
      bars = 10;
      hide_on_silence = true;
      sleep_timer = 5;
      bar_delimiter = 0;
      waves = false;
      monstercat = false;
      noise_reduction = 0.55;
      input_delay = 2;
      ascii_max_range = 8;
      format-icons = [
        "▁"
        "▂"
        "▃"
        "▄"
        "▅"
        "▆"
        "▇"
        "█"
      ];
      actions = {
        on-click-right = "mode";
      };
    };
    battery = {
      format = "{capacity}% {icon}";
      format-icons = [
        " "
        " "
        " "
        " "
        " "
      ];
    };
    "pulseaudio" = {
      "format" = "{volume}% {icon}";
      "format-icons" = {
        "default" = [
          ""
          ""
          ""
        ];
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
  };
}
