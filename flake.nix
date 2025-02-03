{
  description = "my system flake";

  # NOTE: https://github.com/OmniSharp/omnisharp-roslyn/issues/2574
  # NOTE: omnisharp causes shit to go down, for now added insecure package "dotnet-core-combined"
  # NOTE: also same with dotnet-sdk-6.0.428, dotnet-sdk-wrapped-6.0.428, dotnet-runtime-wrapped-6.0.36, dotnet-runtime-6.0.36, dotnet-sdk-7.0.410, dotnet-sdk-wrapped-7.0.410
  # TODO: stylix-nixos.nix, remove overrideAttrs once this is resolved https://github.com/ful1e5/Bibata_Cursor/issues/173

  inputs = {
    # yazi.url = "github:sxyazi/yazi/v0.4.0";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    # TODO: https://github.com/NixOS/nixpkgs/pull/358205
    nixpkgs-termfilechooser.url = "github:bpeetz/nixpkgs/termfilechooser/package";
    # NOTE: https://github.com/NixOS/nixpkgs/pull/295587
    nixpkgs-citra-yuzu-temp.url = "github:Atemu/nixpkgs/revert-yuzu-removal";
    nixpkgs-godot-4.url = "github:nixos/nixpkgs/347b77eba12b3f54850d2824d742f9aa18c1f60d";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/hyprland/v0.47.2";
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      # WM's nixpkgs is only used for tests, you can safely drop this if needed.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    meowvim.url = "github:Eddio0141/meowvim";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    rycee-firefox-extensions.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    swww.url = "github:LGFae/swww";
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      own-pkgs = import ./pkgs {
        inherit
          pkgs
          nixpkgs-options
          inputs
          system
          ;
      };
      username = "yuu";
      nixpkgs-options = {
        inherit system;
        config = {
          allowUnfree = true;
          # rocmSupport = true;
          permittedInsecurePackages = [
            "openssl-1.1.1w"
            "libgcrypt-1.5.3"
            "dotnet-sdk-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
            "dotnet-runtime-wrapped-6.0.36"
            "dotnet-runtime-6.0.36"
            "dotnet-sdk-7.0.410"
            "dotnet-sdk-wrapped-7.0.410"
          ];
        };
      };
      # TODO: this isn't great
      pkgs = import nixpkgs {
        system = nixpkgs-options.system;
        config = nixpkgs-options.config;
      };
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit
            nixpkgs
            inputs
            username
            system
            home-manager
            self
            own-pkgs
            nixpkgs-options
            ;
        }
      );
      packages."${system}" = own-pkgs;
      devShells.${system}.ghidra = pkgs.mkShell {
        packages = with pkgs; [
          python3Packages.psutil
          python3Packages.protobuf3
          lldb
          gdb
        ];
        shellHook = "ghidra";
      };
    };
}
