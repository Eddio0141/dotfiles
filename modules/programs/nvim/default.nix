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
    # TODO i swear there were hm module that enalbes those
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
    };
    # TODO also hm for this too? idk
    environment.systemPackages = [
      (nixvim.makeNixvimWithModule nixvimModule)
    ];
  });
}
