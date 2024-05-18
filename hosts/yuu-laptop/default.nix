{ username, inputs, system, home-manager, pkgs, ... }:
{
  imports = [
    ../../modules/casual.nix
    ./hardware-configuration.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../modules/casual-home.nix
      inputs.hyprland.homeManagerModules.default
    ];
  };

  networking.hostName = "yuu-laptop";

  services.blueman.enable = true;

  yuu.services.syncthing = {
    enable = true;
    device = "laptop";
  };
}
