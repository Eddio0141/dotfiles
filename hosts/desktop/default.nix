{ username, inputs, system, home-manager, ... }:
{
  imports = [
    ../../modules/casual.nix 
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit username inputs system; };
        users.${username} = {
          imports = [
            ../../modules/casual-home.nix
            inputs.hyprland.homeManagerModules.default
          ];
        };
      };
    }
  ];
}
