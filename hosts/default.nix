{ self, nixpkgs, lib, inputs, system, home-manager, username, ... }:
{
  yuu-desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self home-manager; };
    modules = [
      ./yuu-desktop
      ../modules
    ];
  };
  yuu-upwork = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self home-manager; };
    modules = [
      ./yuu-upwork
      ../modules
    ];
  };
}
