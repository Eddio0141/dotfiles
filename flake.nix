{
  description = "my system flake";

  # NOTE: https://github.com/OmniSharp/omnisharp-roslyn/issues/2574

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.45.0&submodules=1";
      # inputs = {
      #   nixpkgs.follows = "nixpkgs";
      #   xdph.follows = "xdph";
      # };
    };
    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix = {
      # url = "github:danth/stylix";
      # TODO: https://github.com/danth/stylix/pull/610
      url = "github:diniamo/stylix/fix-hyprland";
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
    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          rocmSupport = true;
          permittedInsecurePackages = [ "openssl-1.1.1w" ];
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
