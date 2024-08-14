{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.yuu.pack.dri-prime;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;
in
{
  options.yuu.pack.dri-prime.enable = mkEnableOption "dri prime env vars everywhere";

  config = lib.mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [
        (inputs.wrapper-manager.lib.build {
          inherit pkgs;
          modules = [
            {
              wrappers = {
                firefox = {
                  basePackage = (
                    config.programs.firefox.package.override (old: {
                      extraPrefsFiles = old.extraPrefsFiles or [ ] ++ [
                        (pkgs.writeText "firefox-autoconfig.js" config.programs.firefox.autoConfig)
                      ];
                      nativeMessagingHosts =
                        old.nativeMessagingHosts or [ ] ++ config.programs.firefox.nativeMessagingHosts.packages;
                      cfg = (old.cfg or { }) // config.programs.firefox.wrapperConfig;
                    })
                  );
                  env.DRI_PRIME.value = "1";
                };
                vesktop = {
                  basePackage = pkgs.vesktop;
                  env.DRI_PRIME.value = "1";
                };
              };
            }
          ];
        })
      ];
    })

    (mkIf (!cfg.enable) {
      programs.firefox.enable = true;
      environment.systemPackages = with pkgs; [ vesktop ];
    })
  ];
}
