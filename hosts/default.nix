{
  self,
  lib,
  inputs,
  system,
  home-manager,
  username,
  nixpkgs,
  own-pkgs,
  nixpkgs-options,
  ...
}:
let
  nixosSystem = lib.nixosSystem;
  specialArgs = {
    inherit
      username
      inputs
      system
      self
      home-manager
      own-pkgs
      nixpkgs
      nixpkgs-options
      ;
  };
in
{
  yuu-desktop = nixosSystem {
    inherit system specialArgs;
    modules = [
      ./yuu-desktop
    ];
  };
  yuu-upwork = nixosSystem {
    inherit system specialArgs;
    modules = [
      ./yuu-upwork
    ];
  };
  yuu-laptop = nixosSystem {
    inherit system specialArgs;
    modules = [
      ./yuu-laptop
    ];
  };
}
