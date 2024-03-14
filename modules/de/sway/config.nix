{ pkgs }:
let
  mod = "Mod4";
  term = "kitty";
in
{
  startup = [
    { command = "waybar"; }
    { command = "dunst"; }
    { command = "hyprpaper"; }
    { command = "firefox"; }
    { command = "exec clementine"; }
    { command = "dolphin --daemon"; }
    { command = "thunderbird"; }
    { command = "obsidian"; }
    { command = "steam -silent"; }
    { command = "vesktop"; }
    { command = "wl-paste --type text --watch cliphist store"; }
    { command = "wl-paste --type image --watch cliphist store"; }
    { command = "fcitx5 -d"; }
    { command = "thunar --daemon"; }
    { command = "exec ${pkgs.autotiling-rs}/bin/autotiling-rs"; }
  ];
  modifier = "${mod}";
  terminal = "${term}";
  # keycodebindings = {
  #  "XF86AudioRaiseVolume" = "exec pamixer -i 5";
  #  "XF86AudioLowerVolume" = "exec pamixer -d 5";
  #};
  keybindings = pkgs.lib.mkOptionDefault {
    "${mod}+q" = "exec ${term}";
    "${mod}+w" = "kill";
    "${mod}+e" = "exec dolphin";
    "${mod}+t" = "floating toggle";
    "${mod}+s" = "exec wofi --show drun -I -m -i -W 25% -H 75%";
    "${mod}+shift+s" = "move scratchpad";
    "${mod}+ctrl+s" = "scratchpad show";
    # bind = $mainMod, P, pseudo, # dwindle
    # bind = $mainMod, J, togglesplit, # dwindle
    # bind = $mainMod, G, togglegroup,
    # bind = $mainMod, H, lockactivegroup, toggle
    # bind = $mainMod, Next, changegroupactive, f
    # bind = $mainMod, Prior, changegroupactive, b
    # bind = $mainMod SHIFT, End, moveoutofgroup,
    # bind = $mainMod SHIFT, E, workspace, empty
    # bind = $mainMod, mouse_up, workspace, e+1
    # bind = $mainMod, mouse_down, workspace, e-1
    "${mod}+comma" = "focus output DP-3";
    "${mod}+period" = "focus output HDMI-A-1";
    "ctrl+print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify savecopy area";
    "${mod}+alt+p" = "exec clementine --play-pause";
    "${mod}+alt+o" = "exec clementine --next";
    "${mod}+alt+i" = "exec clementine --previous";
    "ctrl+alt+delete" = "exec sway exit";
  };
  input = {
    "*" = {
      xkb_layout = "gb";
      accel_profile = "flat";
      pointer_accel = "-0.35";
    };
  };
  output = {
    HDMI-A-1.mode = "1920x1080@60Hz";
    DP-3.mode = "1920x1080@144Hz";
  };
  bars = [ ];
  window = {
    titlebar = false;
    border = 3;
  };
  gaps = {
    outer = 20;
    inner = 5;
  };
  floating.titlebar = false;
  colors = {
    focused = {
      border = "ff8cec";
      background = "ff8cec";
      text = "ffffff";
      indicator = "ff8cec";
      childBorder = "ff8cec";
    };
  };
}
