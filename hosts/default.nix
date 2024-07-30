{ self, lib, inputs, system, home-manager, username, pkgs-stable, pkgs, own-pkgs, ... }:
let
  nixosSystem = lib.nixosSystem;
  specialArgs = { inherit username inputs system self home-manager pkgs-stable pkgs own-pkgs; };
in
{
  yuu-desktop = nixosSystem {
    inherit system specialArgs;
    modules = [
      ./yuu-desktop
      ../modules
    ];
  };
  yuu-upwork = nixosSystem {
    inherit system specialArgs;
    modules = [
      ./yuu-upwork
      ../modules
    ];
  };
  yuu-laptop = nixosSystem {
    inherit system specialArgs;
    modules = [
      ./yuu-laptop
      ../modules
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ];
  };
}
