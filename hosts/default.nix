{ self, nixpkgs, lib, inputs, system, home-manager, username, ... }:
{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self home-manager; };
    modules = [
      ./desktop
      ../modules
    ];
  };
  upwork = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self home-manager; };
    modules = [
      ./upwork
      ../modules
    ];
  };
}
