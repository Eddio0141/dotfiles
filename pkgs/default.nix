{ pkgs, inputs, system }:
  import ./scripts { inherit pkgs inputs; } //
  import ./programs { inherit pkgs inputs system; }
