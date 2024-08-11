{ config, lib, inputs, pkgs, ... }:
let
  cfg = config.yuu.pack.dri-prime;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;
in
{
  options.yuu.pack.dri-prime.enable = mkEnableOption "dri prime env vars everywhere";

  config = (mkIf cfg.enable {
    environment.systemPackages = [
      (inputs.wrapper-manager.lib.build {
        inherit pkgs;
        modules = [
          {
            wrappers.firefox = {
              basePackage = pkgs.firefox;
              env.DRI_PRIME.value = "1";
            };
            wrappers.vesktop = {
              basePackage = pkgs.vesktop;
              env.DRI_PRIME.value = "1";
            };
          }
        ];
      })
    ];
  });
}
