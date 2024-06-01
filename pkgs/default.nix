{ pkgs, ... }:
let
  callPackage = pkgs.callPackage;
  mkDerivation = pkgs.stdenv.mkDerivation;
in
{
  # scripts
  hypr-move-firefox-yt = callPackage ./scripts/hypr-move-firefox-yt { };
  dl-music = callPackage ./scripts/dl-music { };

  # apps
  uabea = callPackage./apps/uabea { };
}
