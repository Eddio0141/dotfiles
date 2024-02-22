{ inputs, system, username, home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit username inputs system; };
        users.${username} = {
          imports = [
          ];
        };
      };
    }
  ];
}
