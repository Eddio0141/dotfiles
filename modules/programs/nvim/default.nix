{ config, lib, pkgs, inputs, system, username, ... }:
let
  cfg = config.yuu.programs.nvim;
  nixvim = inputs.nixvim.legacyPackages.${system};
  nixvimModule = {
    inherit pkgs;
    module = ./config;
    # extraSpecialArgs = {};
  };
in
{
  options.yuu.programs.nvim.enable = lib.mkEnableOption "nvim";

  config = (lib.mkIf cfg.enable {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
    };
    # TODO: also hm for this too? idk
    environment.systemPackages = [
    #   (nixvim.makeNixvimWithModule nixvimModule)
      pkgs.nvim-pkg
    ];
    nixpkgs.overlays = [
      inputs.meowvim.overlays.default
      # NOTE: check flake.nix
      # TODO: this is not working fuck this
      # (final: prev: {
      #   omnisharp-roslyn = prev.omnisharp-roslyn.overrideAttrs {
      #     version = "1.39.11-fix";
      #     src = prev.fetchFromGitHub {
      #       owner = "Eddio0141";
      #       repo = "omnisharp-roslyn";
      #       rev = "fix-nvim-lsp";
      #       hash = "sha256-FyWHdug2NZGGcn7/eiTi0RklxdC+rtEb51+/l8lebk4=";
      #     };
      #   };
      # })
    ];

    home-manager.users.${username}.programs.zsh.shellAliases = { vimdiff = "nvim -d"; vi = "nvim"; vim = "nvim"; };
  });
}
