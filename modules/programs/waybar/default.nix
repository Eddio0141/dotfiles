{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib;
let
  cfg = config.yuu.programs.waybar;
in
{
  options.yuu.programs.waybar.enable = mkEnableOption "waybar";

  config = (
    mkIf cfg.enable {
      home-manager.users.${username}.programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        style = ./style.css;
        settings = import ./config.nix;
      };
    }
  );
}
