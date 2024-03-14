{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.programs.kitty;
in
{
  options.yuu.programs.kitty.enable = mkEnableOption "kitty";

  config = (mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty
    ];
    
    home-manager.users.${username}.programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        package = (pkgs.nerdfonts.override {
          fonts = [ "JetBrainsMono" ];
        });
      };
      shellIntegration = {
        enableZshIntegration = true;
      };
    };
  });
}
