{ config, lib, pkgs, inputs, system, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.de.hyprland;
in
{
  options.yuu.de.hyprland.enable = mkEnableOption "hyprland";

  config = (mkIf cfg.enable {
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

    # cachix for hyprland
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" "https://devenv.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${system}.default;
      portalPackage = inputs.xdph.packages.${system}.default;
    };

    environment.systemPackages = with pkgs; [
      dunst
      pavucontrol
      kitty
    ];

    yuu.programs.waybar.enable = true;

    home-manager.users.${username} = {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        xwayland.enable = true;
        # if variable or colours, quote them
        settings = import ./config.nix;
      };
    };
  });
}
