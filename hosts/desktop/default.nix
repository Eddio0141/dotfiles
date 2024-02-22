{ username, inputs, system, home-manager, ... }:
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
}
