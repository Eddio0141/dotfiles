{
  config,
  lib,
  pkgs,
  inputs,
  system,
  home-manager,
  username,
  ...
}:
with lib;
let
  cfg = config.yuu.security.polkit-gnome;
in
{
  options.yuu.security.polkit-gnome.enable = mkEnableOption "polkit-gnome";

  config = (
    mkIf cfg.enable {
      # polkit agent
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    }
  );
}
