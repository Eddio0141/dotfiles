{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
let
  cfg = config.yuu.programs.nvim;
in
{
  options.yuu.programs.nvim.enable = lib.mkEnableOption "nvim";

  config = (
    lib.mkIf cfg.enable {
      environment.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        GIT_EDITOR = "nvim";
      };
      environment.systemPackages = [
        pkgs.nvim-pkg
      ];
      nixpkgs.overlays = [
        inputs.meowvim.overlays.default
      ];

      home-manager.users.${username}.programs.nushell.shellAliases = {
        vimdiff = "nvim -d";
        vi = "nvim";
        vim = "nvim";
      };
    }
  );
}
