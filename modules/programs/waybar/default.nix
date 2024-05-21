{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.programs.waybar;
in
{
  options.yuu.programs.waybar.enable = mkEnableOption "waybar";

  config = (mkIf cfg.enable {
    fonts.packages = with pkgs; [
      font-awesome  
    ];
    
    home-manager.users.${username}.programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      # TODO: review and maybe override or remove later on
      # style = ./style.css;
      settings = import ./config.nix;
    };
  });
}
