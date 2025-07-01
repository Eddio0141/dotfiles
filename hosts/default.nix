{
  self,
  inputs,
  home-manager,
  username,
  nixpkgs,
}:
let
  nixosSystem = nixpkgs.lib.nixosSystem;
  baseSpecialArgs = system: {
    inherit
      username
      inputs
      self
      home-manager
      nixpkgs
      ;

    pkgs-stable = (
      import inputs.nixpkgs-stable {
        inherit system;
        config = {
          permittedInsecurePackages = [
            "openssl-1.1.1w"
            "dotnet-sdk-7.0.410"
            "dotnet-sdk-wrapped-7.0.410"
          ];
        };
      }
    );
  };
in
{
  yuu-desktop = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = (baseSpecialArgs system) // {
      inherit system;
    };
    modules = [
      ./yuu-desktop
    ];
  };
  yuu-upwork = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = (baseSpecialArgs system) // {
      inherit system;
    };
    modules = [
      ./yuu-upwork
    ];
  };
  yuu-laptop = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = (baseSpecialArgs system) // {
      inherit system;
    };
    modules = [
      ./yuu-laptop
    ];
  };
  yuu-work-laptop = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = (baseSpecialArgs system) // {
      inherit system;
      username = "edcope";
    };
    modules = [
      ./yuu-work-laptop
    ];
  };
}
