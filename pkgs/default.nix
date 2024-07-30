{ pkgs, ... }:
let
  callPackage = pkgs.callPackage;
in
{
  # scripts
  hypr-move-firefox-yt = callPackage ./scripts/hypr-move-firefox-yt { };
  dl-music = callPackage ./scripts/dl-music { };

  # apps
  uabea = callPackage ./apps/uabea { };
  binaryninja-free = callPackage ./apps/binaryninja { free = true; };
}
