{ config, lib, pkgs, inputs, system, ... }:
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
    # TODO: i swear there were hm module that enables those
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
    };
    # TODO: also hm for this too? idk
    environment.systemPackages = [
      (nixvim.makeNixvimWithModule nixvimModule)
    ];

    nixpkgs.overlays = [
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
  });
}
