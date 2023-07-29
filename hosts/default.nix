{ lib, inputs, system, home-manager, username, hyprcontrib, hyprwm, ... }:

{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs hyprcontrib; };
    modules = [
      ../configuration.nix
      ./desktop

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit username hyprwm; };
        home-manager.users.${username} = {
          imports = [ ../home.nix ];
        };
      }
    ];
  };
}
