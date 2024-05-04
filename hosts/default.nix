{ self, nixpkgs, lib, inputs, system, home-manager, username, pkgs-stable, ... }:
{
  yuu-desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self home-manager pkgs-stable; };
    modules = [
      ./yuu-desktop
      ../modules
    ];
  };
  yuu-upwork = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self home-manager pkgs-stable; };
    modules = [
      ./yuu-upwork
      ../modules
    ];
  };
  yuu-laptop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit username inputs system self home-manager pkgs-stable; };
    modules = [
      ./yuu-laptop
      ../modules
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ];
  };
}
