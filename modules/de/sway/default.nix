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
  });
}
