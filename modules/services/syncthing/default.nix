{ config, lib, username, ... }:
with lib;
let
  cfg = config.yuu.services.syncthing;
  allDevices = {
    mobile = {
      id = "ZOW4POS-N3SKSZ5-ECM6NB7-ICMENDW-LRYONHP-CPXJNHI-BU77TE5-T6W2MQM";
    };
    pixel7 = {
      id = "TJC3PXB-MGZLOID-CY3FEQN-K3E6AIZ-5AORONW-KRJGODY-RCDLBFM-FKCIYAK";
    };
    # TODO: replace laptop with new laptop
    laptop = {
      id = "XTDP5I6-5NPJXNL-CQIYBAP-TN75VCX-37RWFBV-YAJSB6X-6URZYEN-HG7EJQP";
    };
  };
in
{
  options.yuu.services.syncthing = {
    enable = mkEnableOption "syncthing";
    device = mkOption {
      type = types.str;
      description = "which device is this";
    };
  };

  config = (mkIf cfg.enable {
    services.syncthing = {
      user = "${username}";
      group = "wheel";
      dataDir = "/home/${username}/.config/syncthing";
      openDefaultPorts = true;
      settings =
      let
        filteredDevices = filterAttrs (key: _: key != cfg.device) allDevices;
      in
      {
        devices = filteredDevices;
        extraOptions = {
          startBrowser = false;
          urAccepted = -1;
        };
        folders =
        let
          deviceNames = builtins.attrNames filteredDevices;
        in
        {
          "/home/${username}/Documents/Obsidian" = {
            id = "obsidian";
            devices = deviceNames;
          };
          "/home/${username}/sync" = {
            id = "sync";
            devices = deviceNames;
          };
          "/home/${username}/Music" = {
            id = "music";
            devices = deviceNames;
          };
        };
      };
      enable = true;
    };
  });
}
