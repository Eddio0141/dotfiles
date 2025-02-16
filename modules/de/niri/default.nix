{
  config,
  lib,
  username,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.yuu.de.niri;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;
  # TODO: make this its own thing? (its a duplicate from hyprland module)
  xdg-desktop-portal-termfilechooser =
    inputs.nixpkgs-termfilechooser.legacyPackages.x86_64-linux.xdg-desktop-portal-termfilechooser;
in
{
  options.yuu.de.niri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable {
    programs.niri.enable = true;
    # programs.niri.package = pkgs.niri-unstable;

    environment.systemPackages = with pkgs; [
      xwayland-satellite-unstable
      xdg-desktop-portal-termfilechooser
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

    nix.settings = {
      substituters = [ "https://niri.cachix.org" ];
      trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
    };

    yuu = {
      programs = {
        waybar.enable = true;
        kitty.enable = true;
      };
      security.polkit-gnome.enable = true;
    };

    home-manager.users.${username} = {
      programs = {
        niri.settings = import ./settings.nix config.home-manager.users.${username}.lib.niri.actions;
        hyprlock.enable = true;

        wlogout.enable = true;
        waybar.settings.mainBar = {
          modules-left = [ "niri/workspaces" ];
          modules-center = [ "niri/window" ];
        };
      };

      xdg.configFile = {
        "xdg-desktop-portal/portals.conf" = {
          enable = true;
          text = ''
            [preferred]
            default = gnome;gtk;
            org.freedesktop.impl.portal.FileChooser = termfilechooser
          '';
        };
        # "xdg-desktop-portal-termfilechooser/config" = {
        #   enable = true;
        #   text = ''
        #     [filechooser]
        #     cmd=yazi-wrapper.sh
        #     default_dir=$HOME
        #   '';
        # };
      };
    };
  };
}
