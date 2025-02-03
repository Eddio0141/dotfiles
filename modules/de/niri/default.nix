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
    inputs.nixpkgs-termfilechooser.legacyPackages.x86_64-linux.xdg-desktop-portal-termfilechooser.overrideAttrs
      {
        src = pkgs.fetchFromGitHub {
          owner = "boydaihungst";
          repo = "xdg-desktop-portal-termfilechooser";
          rev = "9ba9f982424b0271d6209e1055e934205fa7bc01";
          hash = "sha256-MOS2dS2PeH5O0FKxZfcJUAmCViOngXHZCyjRmwAqzqE=";
        };
        patches = [ ];
      };
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

        waybar.settings.mainBar = {
          modules-left = [ "niri/workspaces" ];
          modules-center = [ "niri/window" ];
        };
      };

      xdg.configFile = {
        "xdg-desktop-portal/portals.conf" = {
          enable = true;
          text = ''
            org.freedesktop.impl.portal.FileChooser=termfilechooser
          '';
        };
        "xdg-desktop-portal-termfilechooser/config" = {
          enable = true;
          text = ''
            [filechooser]
            cmd=${xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
            default_dir=$HOME
          '';
        };
      };
    };
  };
}
