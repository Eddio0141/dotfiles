let
  mod = "Mod4";
  term = "${pkgs.kitty}/bin/kitty";
in {
  startup = [
    { command = "waybar"; always = true; }
    { command = "dunst"; always = true; }
    { command = "hyprpaper"; always = true; }
    { command = "firefox"; always = true; }
    { command = "clementine"; always = true; }
    { command = "dolphin --daemon"; always = true; }
    { command = "thunderbird"; always = true; }
    { command = "obsidian"; always = true; }
    { command = "steam -silent"; always = true; }
    { command = "vesktop"; always = true; }
    { command = "wl-paste --type text --watch cliphist store"; always = true; }
    { command = "wl-paste --type image --watch cliphist store"; always = true; }
    { command = "fcitx5 -d"; always = true; }
    { command = "thunar --daemon"; always = true; }
    { command = "${pkgs.autotiling-rs}"; always = true; }
  ];
  modifier = "${mod}";
  terminal = "${term}";
  keycodebindings = pkgs.lib.mkOptionDefault {
    "XF86AudioRaiseVolume" = "exec pamixer -i 5";
    "XF86AudioLowerVolume" = "exec pamixer -d 5";
  };
  keybindings = pkgs.lib.mkOptionDefault {
    "${mod}+q" = "exec ${term}";
    "${mod}+w" = "kill";
    "${mod}+e" = "dolphin";
    "${mod}+t" = "floating toggle";
    "${mod}+s" = "wofi --show drun -I -m -i -W 25% -H 75%";
    # bind = $mainMod, P, pseudo, # dwindle
    # bind = $mainMod, J, togglesplit, # dwindle
    # bind = $mainMod, F, fullscreen,
    # bind = $mainMod, G, togglegroup,
    # bind = $mainMod, H, lockactivegroup, toggle
    # bind = $mainMod, Next, changegroupactive, f
    # bind = $mainMod, Prior, changegroupactive, b
    # bind = $mainMod SHIFT, End, moveoutofgroup,
    # bind = $mainMod SHIFT, E, workspace, empty

    # bind = $mainMod, mouse_up, workspace, e+1
    # bind = $mainMod, mouse_down, workspace, e-1

    # bindm = $mainMod, mouse:272, movewindow
    # bindm = $mainMod, mouse:273, resizewindow

    # bind = $mainMod, comma, focusmonitor, 0
    # bind = $mainMod, period, focusmonitor, 1

    "ctrl+print" = "grimblast --notify --freeze copysave area";

    "${mod}+alt+p" = "clementine --play-pause";
    "${mod}+alt+o" = "clementine --next";
    "${mod}+alt+i" = "clementine --previous";
  };
};
