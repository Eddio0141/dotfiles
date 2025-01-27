{
  pkgs,
  cfg,
  lib,
}:
let
  mainMod = "SUPER";
  # for various applications that I don't always use
  recordingMod = "ALT";
  moveWindowMod = "SHIFT";
  moveMod = "CTRL";
  miscMod = "SHIFT ALT";
in
{
  # "$border_pink_active" = "rgba(ff8cecff)";
  # "$border_pink_inactive" = "rgba(595959aa)";

  # automatically add new monitors
  monitor = [ ",preferred,auto,1" ] ++ cfg.monitors;
  env = [
    # scaling
    "GDK_SCALE,${builtins.toString cfg.xwaylandScale}"
    "GTK_USE_PORTAL,1"
  ];
  exec-once = [
    "waybar"
    "dunst"
    "firefox"
    "strawberry"
    "fcitx5 -d"
    "[ workspace special silent ] slack"

    "[ workspace special silent ] thunderbird"
    "obsidian"
    "vesktop"

    # TODO fix this
    # "noisetorch -i alsa_input.usb-Razer_Inc_Razer_Seiren_Mini_UC2220L03401755-00.mono-fallback"

    # cliphist
    "wl-paste --type text --watch cliphist store" # Stores only text data
    "wl-paste --type image --watch cliphist store" # Stores only image data

    "swww-daemon"
    "waypaper --restore"
  ] ++ cfg.exec-once;
  windowrulev2 = [
    # vesktop
    "workspace 2 silent, class:^(vesktop)$"

    # thunderbird
    "workspace special silent, class:^thunderbird$"

    # obsidian
    "workspace 2 silent, class:^(obsidian)$"

    # half life tas stuff
    "fullscreen,title:Bunnymod XT Debug Console"
    "tile,title:Bunnymod XT Debug Console"

    "tile,class:hl.exe"

    # jetbrains
    # TODO: better regex
    "dimaround,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
    "center,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
    "noanim,class:^(jetbrains-.*)$,title:^(win.*)$"
    "noinitialfocus,class:^(jetbrains-.*)$,title:^(win.*)$"
    "rounding 0,class:^(jetbrains-.*)$,title:^(win.*)$"

    # unity reload domain, TODO make it check if its from unity
    "noinitialfocus,class:Unity,floating:1"
    "size 650 650,class:Unity,title:Build Settings"
    # unity initial window
    "center,class:^Unity$,initialTitle:^Unity$,floating:0"
    "float,class:^Unity$,initialTitle:^Unity$,floating:0"

    # steam notification
    "nofocus,class:steam,title:^notificationtoasts_\d+_desktop$"

    # cs2 tearing
    # "immediate, class:^(cs2)$"

    # ghidra
    "nofocus,class:^ghidra-Ghidra$,title:^win\d+$"
    "tile,class:^ghidra-Ghidra$,initialTitle:^CodeBrowser$" # main window

    # calc
    "float,initialClass:^org.gnome.Calculator$"

    # ilspy
    "center,initialClass:^ILSp$,title:^Open file$"

    # qemu
    "allowsinput on,initialClass:^.qemu-system-"
  ];
  input = {
    kb_layout = "gb";
    kb_options = "caps:escape";
    follow_mouse = 1;
    sensitivity = -0.35;
    accel_profile = "flat";
  };
  device = {
    name = "pixa3854:00-093a:0274-touchpad";
    sensitivity = 0.5;
  };
  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 3;
    "col.active_border" = lib.mkForce "rgba(ffffffff)";
    # "col.inactive_border" = "$border_pink_inactive";
    layout = "dwindle";
    allow_tearing = false;
  };
  decoration = {
    rounding = 5;
    blur.enabled = true;
    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
    };
  };
  animations = {
    enabled = "yes";
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };
  dwindle = {
    pseudotile = "yes";
    preserve_split = "yes";
  };
  master.new_status = "master";
  gestures.workspace_swipe = "off";
  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    enable_swallow = true;
  };
  render = {
    direct_scanout = false;
  };
  xwayland = {
    force_zero_scaling = true;
  };
  group = {
    # "col.border_active" = "$border_pink_active";
    # "col.border_inactive" = "$border_pink_inactive";
    groupbar = {
      # "col.active" = "rgba(b700ffff)";
      # "col.inactive" = "rgba(3c0054aa)";
    };
  };
  # ecosystem = {
  #   no_donation_nag = true;
  # };

  bind = [
    # general binds
    "${mainMod}, Q, exec, kitty"
    "${mainMod}, W, killactive,"
    "${mainMod}, E, exec, kitty yazi"
    "${mainMod}, S, exec, pidof wofi || wofi --show drun -I -m -i -W 30% -H 75%"

    "CTRL ALT, Delete, exec, pidof wlogout || wlogout"
    "CTRL ALT, BackSpace, exec, hyprlock"

    "${mainMod}, T, togglefloating, "
    "${mainMod}, P, pseudo,"
    "${mainMod}, U, togglesplit,"
    "${mainMod}, F, fullscreen,"
    "${mainMod}, G, togglegroup,"

    "${mainMod}, End, lockactivegroup, toggle"
    "${mainMod}, Next, changegroupactive, f"
    "${mainMod}, Prior, changegroupactive, b"
    "${mainMod} ${moveWindowMod}, End, moveoutofgroup,"

    # Move focus with mainMod + arrow keys
    "${mainMod}, left, movefocus, l"
    "${mainMod}, right, movefocus, r"
    "${mainMod}, up, movefocus, u"
    "${mainMod}, down, movefocus, d"
    "${mainMod}, h, movefocus, l"
    "${mainMod}, l, movefocus, r"
    "${mainMod}, k, movefocus, u"
    "${mainMod}, j, movefocus, d"

    # Move windows with mainMod + moveWindowMod + arrow keys
    "${mainMod} ${moveWindowMod}, left, movewindow, l"
    "${mainMod} ${moveWindowMod}, right, movewindow, r"
    "${mainMod} ${moveWindowMod}, up, movewindow, u"
    "${mainMod} ${moveWindowMod}, down, movewindow, d"
    "${mainMod} ${moveWindowMod}, h, movewindow, l"
    "${mainMod} ${moveWindowMod}, l, movewindow, r"
    "${mainMod} ${moveWindowMod}, k, movewindow, u"
    "${mainMod} ${moveWindowMod}, j, movewindow, d"

    # Switch workspaces with mainMod + [0-9]
    "${mainMod}, 1, workspace, 1"
    "${mainMod}, 2, workspace, 2"
    "${mainMod}, 3, workspace, 3"
    "${mainMod}, 4, workspace, 4"
    "${mainMod}, 5, workspace, 5"
    "${mainMod}, 6, workspace, 6"
    "${mainMod}, 7, workspace, 7"
    "${mainMod}, 8, workspace, 8"
    "${mainMod}, 9, workspace, 9"
    "${mainMod}, 0, workspace, 10"

    # Switch workspaces
    "${mainMod} ${moveMod}, h, workspace, e-1"
    "${mainMod} ${moveMod}, l, workspace, e+1"

    # Move active window to a workspace with mainMod + moveWindowMod + [0-9]
    "${mainMod} ${moveWindowMod}, 1, movetoworkspace, 1"
    "${mainMod} ${moveWindowMod}, 2, movetoworkspace, 2"
    "${mainMod} ${moveWindowMod}, 3, movetoworkspace, 3"
    "${mainMod} ${moveWindowMod}, 4, movetoworkspace, 4"
    "${mainMod} ${moveWindowMod}, 5, movetoworkspace, 5"
    "${mainMod} ${moveWindowMod}, 6, movetoworkspace, 6"
    "${mainMod} ${moveWindowMod}, 7, movetoworkspace, 7"
    "${mainMod} ${moveWindowMod}, 8, movetoworkspace, 8"
    "${mainMod} ${moveWindowMod}, 9, movetoworkspace, 9"
    "${mainMod} ${moveWindowMod}, 0, movetoworkspace, 10"

    # empty workspace
    "${mainMod} ${moveMod}, e, workspace, empty"
    "${mainMod} ${moveWindowMod}, e, movetoworkspace, empty"

    # Special workspace actions
    "${mainMod} ${moveWindowMod}, S, movetoworkspacesilent, special"
    "${mainMod} ${moveMod}, S, togglespecialworkspace"

    # Scroll through existing workspaces with mainMod + scroll
    "${mainMod}, mouse_up, workspace, e+1"
    "${mainMod}, mouse_down, workspace, e-1"

    # Switch monitors
    "${mainMod}, comma, focusmonitor, 0"
    "${mainMod}, period, focusmonitor, 1"

    # screenshot
    "CTRL, Print, exec, grimblast --notify --freeze copysave area"
    ", Print, exec, grimblast --notify copysave output"

    # volume
    ", XF86AudioRaiseVolume, exec, pamixer --increase 5"
    ", XF86AudioLowerVolume, exec, pamixer --decrease 5"
    ", XF86AudioMute, exec, pamixer --toggle-mute"

    # media control
    "${miscMod}, P, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
    "${miscMod}, O, exec, ${pkgs.playerctl}/bin/playerctl next"
    "${miscMod}, I, exec, ${pkgs.playerctl}/bin/playerctl previous"
    ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
    ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
    ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
    ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"

    # to let you use arrow keys
    # these binds also unpress whatever miscMod is pressing
    "${miscMod}, H, exec, ydotool key 42:0 56:0 105:1 105:0"
    "${miscMod}, L, exec, ydotool key 42:0 56:0 106:1 106:0"
    "${miscMod}, J, exec, ydotool key 42:0 56:0 108:1 108:0"
    "${miscMod}, K, exec, ydotool key 42:0 56:0 103:1 103:0"

    # gpu-screen-recorder
    # TODO: expand on this and make it better
    "${recordingMod}, F9, exec, ${pkgs.dunst}/bin/dunstify -a gpu-screen-recorder -u low 'F9 key' && ${pkgs.killall}/bin/killall -SIGINT gpu-screen-recorder"
    "${recordingMod}, F10, exec, ${pkgs.dunst}/bin/dunstify -a 'GPU Screen Recorder' -u low 'Replay saved' && ${pkgs.killall}/bin/killall -SIGUSR1 gpu-screen-recorder"
  ];

  bindm = [
    # Move/resize windows with mainMod + LMB/RMB and dragging
    "${mainMod}, mouse:272, movewindow"
    "${mainMod}, mouse:273, resizewindow"
  ];

  plugin = {
    hyprbars = {
      bar_height = 20;
      bar_blur = true;
    };
  };
}
