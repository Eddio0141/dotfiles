{ pkgs, ... }:
let
  callPackage = pkgs.callPackage;
in
{
  # scripts
  dl-music = callPackage ./scripts/dl-music { };

  # apps
  uabea = callPackage ./apps/uabea { };
  binaryninja-free = callPackage ./apps/binaryninja { free = true; };
}
