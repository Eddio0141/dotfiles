{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.de.sway;
in
{
  options.yuu.de.sway.enable = mkEnableOption "sway";

  config = (mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dunst
      pavucontrol
    ];
    
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      extraSessionCommands = ''
      export GDK_BACKEND=wayland,x11
      export QT_QPA_PLATFORM="wayland;xcb"
      export QT_QPA_PLATFORMTHEME=qt5ct
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      '';
    };

    yuu = {
      programs = {
        waybar.enable = true;
        kitty.enable = true;
      };
      security.polkit-gnome.enable = true;
    };

    home-manager.users.${username}.wayland.windowManager.sway = {
      enable = true;
      package = null;
      systemd.enable = true;
      swaynag.enable = true;
      config = import ./config.nix { inherit pkgs; };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  });
}
