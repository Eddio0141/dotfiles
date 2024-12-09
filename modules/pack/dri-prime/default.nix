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
in
# wrappers =
#   (inputs.wrapper-manager.lib {
#     inherit pkgs;
#     modules = [
#       {
#         wrappers = {
#           steam = {
#             basePackage = pkgs.steam;
#             env.DRI_PRIME.value = "0";
#           };
#         };
#       }
#     ];
#   }).config.build.packages;
{
  options.yuu.pack.dri-prime.enable = mkEnableOption "dri prime env vars everywhere";

  config = lib.mkMerge [
    (mkIf cfg.enable {
      # environment.systemPackages = with wrappers; [
      # ];

      programs.steam.package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          DRI_PRIME = false;
        };
      };

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
