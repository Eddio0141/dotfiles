{
  self,
  inputs,
  home-manager,
  username,
  nixpkgs,
}:
let
  nixosSystem = nixpkgs.lib.nixosSystem;
  baseSpecialArgs = {
    inherit
      username
      inputs
      self
      home-manager
      nixpkgs
      ;
  };
in
{
  yuu-desktop = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = baseSpecialArgs // {
      inherit system;
    };
    modules = [
      ./yuu-desktop
    ];
  };
  yuu-upwork = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = baseSpecialArgs // {
      inherit system;
    };
    modules = [
      ./yuu-upwork
    ];
  };
  yuu-laptop = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = baseSpecialArgs // {
      inherit system;
    };
    modules = [
      ./yuu-laptop
    ];
  };
}
