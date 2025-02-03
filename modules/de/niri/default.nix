{
  config,
  lib,
  username,
  pkgs,
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
    programs.niri.enable = true;
    # programs.niri.package = pkgs.niri-unstable;

    environment.systemPackages = with pkgs; [
      xwayland-satellite-unstable
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
      programs.niri.settings =
        import ./settings.nix
          config.home-manager.users.${username}.lib.niri.actions;
    };
  };
}
