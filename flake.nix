{
  # NOTE: dotnet-sdk-6.0.428, dotnet-sdk-wrapped-6.0.428, dotnet-runtime-wrapped-6.0.36, dotnet-runtime-6.0.36, dotnet-sdk-7.0.410, dotnet-sdk-wrapped-7.0.410
  # TODO: stylix-nixos.nix, remove overrideAttrs once this is resolved https://github.com/ful1e5/Bibata_Cursor/issues/173

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # TODO: https://github.com/NixOS/nixpkgs/pull/369193 broke obs browser sources on purpose
    # NOTE: https://github.com/NixOS/nixpkgs/pull/295587 citra / yuzu
    # nixpkgs-citra-yuzu-temp.url = "github:Atemu/nixpkgs/revert-yuzu-removal";
    # nixpkgs-godot-4.url = "github:nixos/nixpkgs/347b77eba12b3f54850d2824d742f9aa18c1f60d";
    # TODO: this is to fix igpu on laptop by rolling back mesa
    # nixpkgs-mesa.url = "github:nixos/nixpkgs/bcad4f36b978bd56017dd57bfb71892ce9c9e959";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprcontrib = {
    #   url = "github:hyprwm/contrib";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprland.url = "github:hyprwm/hyprland/v0.47.2";
    # hyprpicker = {
    #   url = "github:hyprwm/hyprpicker";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    wrapper-manager.url = "github:viperML/wrapper-manager";
    meowvim.url = "github:Eddio0141/meowvim";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    swww.url = "github:LGFae/swww";
    niri.url = "github:sodiboo/niri-flake";
    ouch-yazi = {
      url = "github:ndtoan96/ouch.yazi";
      flake = false;
    };
    restore-yazi = {
      url = "github:boydaihungst/restore.yazi";
      flake = false;
    };
    # yazi.url = "github:sxyazi/yazi/v25.3.2";
    yazi-rs-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
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
      username = "yuu";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit
            nixpkgs
            inputs
            username
            home-manager
            self
            ;
        }
      );
    };
}
