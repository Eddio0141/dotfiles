{
  config,
  lib,
  username,
  ...
}:
with builtins;
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
  options.yuu.services.syncthing.enable = lib.mkEnableOption "syncthing";

  config = (
    lib.mkIf cfg.enable {
      services.syncthing = {
        user = "${username}";
        group = "wheel";
        dataDir = "/home/${username}/.config/syncthing";
        openDefaultPorts = true;
        settings =
          let
            filteredDevices = lib.filterAttrs (key: _: key != hostName) allDevices;
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
                # pixel7 doesn't need everything
                deviceNamesExclPixel7 = attrNames (lib.filterAttrs (key: _: key != "pixel7") filteredDevices);
                deviceNamesPcPixel7 = attrNames (
                  lib.filterAttrs (key: _: key == "pixel7" || key == "yuu-desktop") filteredDevices
                );
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
                "/home/${username}/ghidra-projects" = {
                  id = "ghidra-projects";
                  devices = deviceNamesExclPixel7;
                };
                "/home/${username}/binary-ninja-projects" = {
                  id = "binary-ninja-projects";
                  devices = deviceNamesExclPixel7;
                };
                "/home/${username}/Pictures/wallpaper" = {
                  id = "wallpaper";
                  devices = deviceNames;
                };
                "/home/${username}/Pictures/photos" = {
                  id = "photos";
                  devices = deviceNamesPcPixel7;
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
    }
  );
}
