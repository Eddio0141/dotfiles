{
  config,
  lib,
  # inputs,
  # pkgs,
  username,
  ...
}:
let
  cfg = config.yuu.pack.dri-prime;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;

in
# wrappers =
#   (inputs.wrapper-manager.lib {
#     inherit pkgs;
#     modules = [
#       {
#         wrappers = {
#           firefox = {
#             # basePackage = (
#             #   config.programs.firefox.package.override (old: {
#             #     extraPrefsFiles = old.extraPrefsFiles or [ ] ++ [
#             #       (pkgs.writeText "firefox-autoconfig.js" config.programs.firefox.autoConfig)
#             #     ];
#             #     nativeMessagingHosts =
#             #       old.nativeMessagingHosts or [ ] ++ config.programs.firefox.nativeMessagingHosts.packages;
#             #     cfg = (old.cfg or { }) // config.programs.firefox.wrapperConfig;
#             #   })
#             # );
#             basePackage = pkgs.firefox-unwrapped;
#
#             env.DRI_PRIME.value = "1";
#           };
#           vesktop = {
#             basePackage = pkgs.vesktop;
#             env.DRI_PRIME.value = "1";
#           };
#         };
#       }
#     ];
#   }).config.build.packages;
{
  options.yuu.pack.dri-prime.enable = mkEnableOption "dri prime env vars everywhere";

  config = lib.mkMerge [
    (mkIf cfg.enable {
      # environment.systemPackages = [
      #   wrappers.vesktop
      # ];

      home-manager.users.${username} = {
        wayland.windowManager.hyprland.settings.env = [ "DRI_PRIME,1" ];
        # programs.firefox = firefox // {
        #   package = wrappers.firefox;
        # };
      };
    })

    # (mkIf (!cfg.enable) {
    #   environment.systemPackages = with pkgs; [ vesktop ];
    #   home-manager.users.${username} = {
    #     programs.firefox = firefox;
    #   };
    # })
  ];
}
