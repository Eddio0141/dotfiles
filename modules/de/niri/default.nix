{
  config,
  lib,
  username,
  pkgs,
  inputs,
  link,
  ...
}:
let
  cfg = config.yuu.de.niri;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;
in
{
  options.yuu.de.niri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable {
    programs = {
      niri = {
        enable = true;
        # package = pkgs.niri-unstable;
        package = pkgs.niri;
      };
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite-unstable
      inputs.swww.packages.${system}.swww
      waypaper
    ];

    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
    ];

    nixpkgs.overlays = [
      inputs.niri.overlays.niri
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time";
          user = "greeter";
        };
      };
    };

    yuu.programs = {
      waybar.enable = true;
      kitty.enable = true;
      dunst.enable = true;
      wofi.enable = true;
    };

    home-manager.users.${username} = {
      xdg.configFile."niri/config.kdl".source = link ./config.kdl;

      programs = {
        niri.config = null;
        hyprlock.enable = true;

        wlogout.enable = true;
        waybar.settings.mainBar = {
          modules-left = [ "niri/workspaces" ];
          modules-center = [ "niri/window" ];
        };
      };
    };
  };
}
