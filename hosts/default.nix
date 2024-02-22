{ self, nixpkgs, lib, inputs, system, home-manager, username, ... }:
{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self; };
    modules = [
      ./desktop
      ../modules
    ];
  };
  upwork = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self; };
    modules = [
      ./upwork
      ../modules
    ];
  };
}
