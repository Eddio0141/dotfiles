{
  config,
  lib,
  inputs,
  pkgs,
  username,
  ...
}:
let
  cfg = config.yuu.pack.dri-prime;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;
  mkApp = pkg: {
    name = getName pkg;
    value = {
      basePackage = pkg;
      env.DRI_PRIME.value = "0";
    };
  };
  apps = with pkgs; [
    loupe
    gnome-calculator
  ];
  getName = pkg: pkg.pname or pkg.name;
  wrappers =
    (inputs.wrapper-manager.lib {
      inherit pkgs;
      modules = [
        {
          wrappers = builtins.listToAttrs (map mkApp apps);
        }
      ];
    }).config.build.packages;
in
{
  options.yuu.pack.dri-prime.enable = mkEnableOption "dri prime env vars everywhere";

  config = lib.mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = builtins.attrValues wrappers;

      programs.steam.package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          DRI_PRIME = false;
        };
      };

      home-manager.users.${username} = {
        wayland.windowManager.hyprland.settings.env = [ "DRI_PRIME,1" ];
      };
    })

    (mkIf (!cfg.enable) {
      environment.systemPackages = apps;
    })
  ];
}
