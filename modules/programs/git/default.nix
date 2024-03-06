{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.programs.git;
in
{
  options.yuu.programs.git.enable = mkEnableOption "git";

  config = (mkIf cfg.enable {
    home-manager.users.${username}.programs.git = {
      enable = true;
      userName = "Eddio0141";
      userEmail = "eddio0141@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        advice.addIgnoredFile = "false";
        pull.rebase = "false";
      };
    };
  });
}
