{ home-manager, username, config, lib, pkgs, inputs, system, self, ... }:
with lib;
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
  options.yuu.programs.nvim.enable = mkEnableOption "nvim";

  config = (mkIf cfg.enable {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
    };
    environment.systemPackages = [
      self.packages."${system}".nvim
    ];
  });
}
