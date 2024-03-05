{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.de.sway;
in {
  options.yuu.de.sway.enable = mkEnableOption "sway";

  config = (mkIf cfg.enable {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      extraSessionCommands = ''
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME=qt5ct
      '';
    };

    yuu.programs.waybar.enable = true;

    home-manager.users.${username}.wayland.windowManager.sway = {
      enable = true;
      package = null;
      systemd.enable = true;
      swaynag.enable = true;
      config = import ./config.nix { inherit pkgs; };
    };

    environment.systemPackages = with pkgs; [
      kitty
    ];
    
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  });
}
