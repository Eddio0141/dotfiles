{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib;
let
  cfg = config.yuu.programs.fastfetch;
in
{
  options.yuu.programs.fastfetch = {
    enable = mkEnableOption "fastfetch";
    customArt = mkOption {
      type = lib.types.bool;
      description = "custom art for the image";
      default = true;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        fastfetch
      ];
    })
    (mkIf cfg.customArt {
      home-manager.users.${username} = {
        # fastfetch art
        xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON (import ./config.nix);
      };
    })
  ];
}
