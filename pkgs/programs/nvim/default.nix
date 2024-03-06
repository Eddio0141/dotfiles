{ nixvim, pkgs }:
let
  nixvimModule = {
    inherit pkgs;
    module = ./config;
    # extraSpecialArgs = {};
  };
in
nixvim.makeNixvimWithModule nixvimModule
