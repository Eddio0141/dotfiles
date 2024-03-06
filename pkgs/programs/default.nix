{ pkgs, inputs, system, ... }: with pkgs;
let
  nixvim = inputs.nixvim.legacyPackages.${system};
in
{
  nvim = callPackage ./nvim { inherit nixvim; };
}
