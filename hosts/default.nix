{ lib, inputs, system, home-manager, username, ... };

{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgss = { inherit user inputs; };
    modules = [
      ./configuration.nix
      ./desktop

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit username; };
        home-manager.users.${username} = {
          imports = [ ../home.nix ];
        };
      };
  };
}
