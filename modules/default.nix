{ username, inputs, system, home-manager, ... }:
{
  imports = [
    ./de
    ./programs
    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit username inputs system; };
      };
    }
  ];
}
