{
  description = "my system flake";

  inputs = {
    # TODO: programs.gpu-screen-recorder.enable = true; when nixpkgs upgrade
    # TODO: restore
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/262a6fe785d56a5748ba590484f3499b370dbbb8";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # NOTE: https://github.com/NixOS/nixpkgs/pull/287858
    nixpkgs-awatcher-temp.url = "github:nixos/nixpkgs/44a5529bbad6159aaf72b066419081319c37f4a1";
    # NOTE: https://github.com/NixOS/nixpkgs/pull/295587
    nixpkgs-citra-yuzu-temp.url = "github:Atemu/nixpkgs/revert-yuzu-removal";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        xdph.follows = "xdph";
      };
    };
    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-stable, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          rocmSupport = true;
          permittedInsecurePackages = [
            "openssl-1.1.1w"
          ];
        };
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {
          permittedInsecurePackages = [
            "curl-impersonate-0.5.4"
            "curl-impersonate-ff-0.5.4"
            "curl-impersonate-chrome-0.5.4"
          ];
          allowUnfree = true;
        };
      };
      username = "yuu";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit pkgs inputs username system home-manager self pkgs-stable;
        }
      );
      packages."${system}" = import ./pkgs { inherit pkgs inputs system; };
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
