{
  # NOTE: dotnet-sdk-6.0.428, dotnet-sdk-wrapped-6.0.428, dotnet-runtime-wrapped-6.0.36, dotnet-runtime-6.0.36, dotnet-sdk-7.0.410, dotnet-sdk-wrapped-7.0.410
  # TODO: stylix-nixos.nix, remove overrideAttrs once this is resolved https://github.com/ful1e5/Bibata_Cursor/issues/173

  inputs = {
    # yazi.url = "github:sxyazi/yazi/v0.4.0";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # TODO: https://github.com/NixOS/nixpkgs/pull/369193 fucking broke obs browser sources on purpose
    nixpkgs-obs.url = "github:nixos/nixpkgs/be208c66f98e61d50065b41fba656f5524b92512";
    # TODO: https://github.com/NixOS/nixpkgs/pull/358205
    nixpkgs-termfilechooser.url = "github:body20002/nixpkgs/add-xdg-desktop-portal-termfilechooser";
    # NOTE: https://github.com/NixOS/nixpkgs/pull/295587
    # nixpkgs-citra-yuzu-temp.url = "github:Atemu/nixpkgs/revert-yuzu-removal";
    # nixpkgs-godot-4.url = "github:nixos/nixpkgs/347b77eba12b3f54850d2824d742f9aa18c1f60d";
    # TODO: wait for https://github.com/danth/stylix/issues/865 before updating home-manager
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
    wrapper-manager.url = "github:viperML/wrapper-manager";
    meowvim.url = "github:Eddio0141/meowvim";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    rycee-firefox-extensions.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
      dotfilesPath = "/home/${username}/dotfiles";
      yuulib = import ./lib.nix { inherit home-manager dotfilesPath; };
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
            yuulib
            dotfilesPath
            ;
        }
      );
    };
}
