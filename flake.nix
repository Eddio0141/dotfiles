{
  # NOTE: dotnet-sdk-6.0.428, dotnet-sdk-wrapped-6.0.428, dotnet-runtime-wrapped-6.0.36, dotnet-runtime-6.0.36, dotnet-sdk-7.0.410, dotnet-sdk-wrapped-7.0.410
  # TODO: stylix-nixos.nix, remove overrideAttrs once this is resolved https://github.com/ful1e5/Bibata_Cursor/issues/173

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/25.05";
    # TODO: in shared.nix, remove gnome2.GConf override once unityhub builds again https://github.com/NixOS/nixpkgs/issues/418451
    # TODO: https://github.com/NixOS/nixpkgs/pull/369193 broke obs browser sources on purpose
    # NOTE: https://github.com/NixOS/nixpkgs/pull/295587 citra / yuzu
    # nixpkgs-citra-yuzu-temp.url = "github:Atemu/nixpkgs/revert-yuzu-removal";
    # nixpkgs-godot-4.url = "github:nixos/nixpkgs/347b77eba12b3f54850d2824d742f9aa18c1f60d";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
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
    yazi-rs-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    catppuccin-yazi = {
      url = "github:catppuccin/yazi";
      flake = false;
    };
    nix-index.url = "github:nix-community/nix-index";
    rmpc = {
      url = "github:mierak/rmpc";
      flake = false;
    };
    aw-watcher-steam = {
      url = "github:Edwardsoen/aw-watcher-steam";
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
