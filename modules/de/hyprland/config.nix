{ pkgs, ... }:
{
  "$border_pink_active" = "rgba(ff8cecff)";
  "$border_pink_inactive" = "rgba(595959aa)";

  monitor = [
    ",preferred,auto,auto"
    "DP-3, 1920x1080@144, 0x0, 1"
  ];
  env = [
    # disables usage of newer DRM API that doesn't support tearing yet
    "WLR_DRM_NO_ATOMIC,1"
  ];
  exec-once = [
    "waybar"
    "dunst"
    "hyprpaper"
    "firefox"
    "clementine"
    "dolphin --daemon"
    "fcitx5 -d"

    "[ workspace special silent ] thunderbird"
    "obsidian"
    "steam -silent"
    "vesktop"
    "aw-qt"

    # TODO fix this
    # "noisetorch -i alsa_input.usb-Razer_Inc_Razer_Seiren_Mini_UC2220L03401755-00.mono-fallback"

    # cliphist
    "wl-paste --type text --watch cliphist store" # Stores only text data
    "wl-paste --type image --watch cliphist store" # Stores only image data
  ];
  windowrulev2 = [
    # firefox
    "group set lock, class:^firefox$"
    "group invade, class:^firefox$"
    "monitor 0, class:^firefox$"

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
    "windowdance,class:^(jetbrains-.*)$"
    "dimaround,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
    "center,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
    "noanim,class:^(jetbrains-.*)$,title:^(win.*)$"
    "noinitialfocus,class:^(jetbrains-.*)$,title:^(win.*)$"
    "rounding 0,class:^(jetbrains-.*)$,title:^(win.*)$"

    # unity reload domain, TODO make it check if its from unity
    "noinitialfocus,class:Unity,floating:1"
    "size 650 650,class:Unity,title:Build Settings"

    # steam
    #"forceinput,class:steam"

    # steam notification
    "nofocus,class:steam,title:^notificationtoasts_\d+_desktop$"

    # cs2 tearing
    "immediate, class:^(cs2)$"

    # qemu
    "forceinput,class:^qemu-system-.+$"
  ];
  input = {
    kb_layout = "gb";
    follow_mouse = 2;
    sensitivity = -0.35;
    accel_profile = "flat";
  };
  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 3;
    "col.active_border" = "$border_pink_active";
    "col.inactive_border" = "$border_pink_inactive";
    layout = "dwindle";
    allow_tearing = true;
  };
  decoration = {
    rounding = 5;
    drop_shadow = "yes";
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
    blur.enabled = true;
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
  master.new_is_master = true;
  gestures.workspace_swipe = "off";
  misc = {
    enable_swallow = true;
    no_direct_scanout = true;
  };
  xwayland = {
    force_zero_scaling = true;
  };
  group = {
    "col.border_active" = "$border_pink_active";
    "col.border_inactive" = "$border_pink_inactive";
    groupbar = {
      "col.active" = "rgba(b700ffff)";
      "col.inactive" = "rgba(3c0054aa)";
    };
  };

  "$mainMod" = "SUPER";
  "$altCombo" = "SUPER ALT";

  bind = [
    "$mainMod, Q, exec, kitty"
    "$mainMod, W, killactive,"
    "CTRL ALT, Delete, exit,"
    "$mainMod, Delete, exec, ${pkgs.hyprlock}/bin/hyprlock"
    "$mainMod, E, exec, dolphin"
    "$mainMod, T, togglefloating, "
    "$mainMod, S, exec, wofi --show drun -I -m -i -W 25% -H 75%"
    "$mainMod, P, pseudo, # dwindle"
    "$mainMod, U, togglesplit, # dwindle"
    "$mainMod, F, fullscreen,"
    "$mainMod, G, togglegroup,"
    "$mainMod, End, lockactivegroup, toggle"
    "$mainMod, Next, changegroupactive, f"
    "$mainMod, Prior, changegroupactive, b"
    "$mainMod SHIFT, End, moveoutofgroup,"

    # Move focus with mainMod + arrow keys
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    "$mainMod, h, movefocus, l"
    "$mainMod, l, movefocus, r"
    "$mainMod, k, movefocus, u"
    "$mainMod, j, movefocus, d"

    # Move windows with mainMod + SHIFT + arrow keys
    "$mainMod SHIFT, left, movewindow, l"
    "$mainMod SHIFT, right, movewindow, r"
    "$mainMod SHIFT, up, movewindow, u"
    "$mainMod SHIFT, down, movewindow, d"
    "$mainMod SHIFT, h, movewindow, l"
    "$mainMod SHIFT, l, movewindow, r"
    "$mainMod SHIFT, k, movewindow, u"
    "$mainMod SHIFT, j, movewindow, d"

    # Switch workspaces with mainMod + [0-9]
    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0, movetoworkspace, 10"

    # Switch to empty workspace
    "$mainMod SHIFT, E, workspace, empty"

    # Special workspace actions
    "$mainMod SHIFT, S, movetoworkspacesilent, special"
    "$mainMod CTRL, S, togglespecialworkspace"

    # Scroll through existing workspaces with mainMod + scroll
    "$mainMod, mouse_up, workspace, e+1"
    "$mainMod, mouse_down, workspace, e-1"

    # Switch monitors
    "$mainMod, comma, focusmonitor, 0"
    "$mainMod, period, focusmonitor, 1"

    # screenshot
    "CTRL, Print, exec, grimblast --notify --freeze copysave area"

    # volume
    ", XF86AudioRaiseVolume, exec, pamixer -i 5"
    ", XF86AudioLowerVolume, exec, pamixer -d 5"

    # music
    "$altCombo, P, exec, clementine --play-pause"
    "$altCombo, O, exec, clementine --next"
    "$altCombo, I, exec, clementine --previous"

    # gpu-screen-recorder
    # TODO: expand on this and make it better
    "ALT, F9, exec, ${pkgs.killall}/bin/killall -SIGINT gpu-screen-recorder"
    "ALT, F10, exec, ${pkgs.killall}/bin/killall -SIGUSR1 gpu-screen-recorder"
];

  bindm = [
    # Move/resize windows with mainMod + LMB/RMB and dragging
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];
}
