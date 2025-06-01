{
  config,
  lib,
  username,
  pkgs,
  ...
}:
let
  cfg = config.yuu.services.termfilechooser;
in
{
  options.yuu.services.termfilechooser.enable = lib.mkEnableOption "termfilechooser";

  config = (
    lib.mkIf cfg.enable {
      xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
      ];

      programs.thunderbird.preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };

      home-manager.users.${username}.xdg.configFile = {
        "xdg-desktop-portal-termfilechooser/config".text = ''
          [filechooser]
          cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          default_dir=$HOME
        '';
        "xdg-desktop-portal/portals.conf".text = ''
          [preferred]
          default = gnome;gtk;
          org.freedesktop.impl.portal.FileChooser = termfilechooser
        '';
      };
    }
  );
}
