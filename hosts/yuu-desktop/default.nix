{
  username,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/casual.nix
    ./hardware-configuration.nix
    ../../modules
    inputs.niri.nixosModules.niri
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  home-manager.users.${username} = {
    imports = [
      ../../modules/casual-home.nix
      ./home.nix
    ];

    programs.niri.settings.outputs = {
      "DP-3" = {
        position = {
          x = 0;
          y = 0;
        };
        mode = {
          width = 1920;
          height = 1080;
          refresh = 239.76;
        };
      };
      "DP-2".mode = {
        width = 1920;
        height = 1080;
        refresh = 144.001;
      };
    };
  };

  networking.hostName = "${username}-desktop";
}
