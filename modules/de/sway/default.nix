{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.de.sway;
in {
  options.de.sway.enable = mkEnableOption "sway";

  config = (mkIf cfg.enable {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
    };

    home-manager.users.${username}.wayland.windowManager.sway = {
      enable = true;
      package = null;
      systemd.enable = true;
      extraSessionCommands = ''
        export QT_QPA_PLATFORM=wayland
        export QT_QPA_PLATFORMTHEME=qt5ct
      '';
      swaynag.enable = true;
      config = import ./config.nix;
    };
  });
}
