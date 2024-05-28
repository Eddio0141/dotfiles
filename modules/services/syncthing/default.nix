{ config, lib, username, ... }:
with lib; with builtins;
let
  cfg = config.yuu.services.syncthing;
  allDevices = {
    yuu-desktop = {
      id = "J47AZ7V-MNCKDHS-74VGJYZ-KI3I54C-HTWIHJM-DLZHSWB-WZMVCGA-XEUWNAG";
    };
    pixel7 = {
      id = "TJC3PXB-MGZLOID-CY3FEQN-K3E6AIZ-5AORONW-KRJGODY-RCDLBFM-FKCIYAK";
    };
    yuu-laptop = {
      id = "YBEBARB-5APCGQF-2B36JOC-5O7YMJE-5VTLDTJ-KQFMF26-25NHOF3-SCQIJA3";
    };
  };
  hostName = config.networking.hostName;
in
{
  options.yuu.services.syncthing.enable = mkEnableOption "syncthing";

  config = (mkIf cfg.enable {
    services.syncthing = {
      user = "${username}";
      group = "wheel";
      dataDir = "/home/${username}/.config/syncthing";
      openDefaultPorts = true;
      settings =
        let
          filteredDevices = filterAttrs (key: _: key != hostName) allDevices;
        in
        {
          devices = filteredDevices;
          extraOptions = {
            startBrowser = false;
            urAccepted = -1;
          };
          folders =
            let
              deviceNames = attrNames filteredDevices;
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
              "/home/yuu/ghidra-projects" = {
                id = "ghidra-projects";
                devices = deviceNames;
              };
            };
        };
      enable = true;
    };

    assertions = [
      {
        assertion = hasAttr hostName allDevices;
        message = "No syncthing device defined for this host. Add a device for this host in the syncthing module";
      }
    ];
  });
}
