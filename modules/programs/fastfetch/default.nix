{ config, lib, pkgs, username, ... }:
with lib;
let
  cfg = config.yuu.programs.fastfetch;
in
{
  options.yuu.programs.fastfetch.enable = mkEnableOption "fastfetch";

  config = (mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fastfetch
    ];
    
    home-manager.users.${username} = {
      # fastfetch art
      xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON (import ./config.nix);
    };
  });
}
