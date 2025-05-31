{ inputs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.disko.nixosModules.disko
  ];

  # disk setup
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "lassicrypt";
                askPassword = true;
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          rootfs = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "compress=zstd"
                "noatime"
              ];
            };
          };
          swap = {
            size = "48G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
        };
      };
    };
  };
}
