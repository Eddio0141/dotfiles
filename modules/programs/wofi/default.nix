{
  config,
  lib,
  username,
  link,
  pkgs,
  ...
}:
let
  cfg = config.yuu.programs.wofi;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;
in
{
  options.yuu.programs.wofi.enable = mkEnableOption "wofi";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wofi
    ];

    home-manager.users.${username} = {
      xdg.configFile."wofi/style.css".source = link ./style.css;
      xdg.configFile."wofi/config".source = link ./config;
    };
  };
}
