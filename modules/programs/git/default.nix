{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.yuu.programs.git;
in
{
  options.yuu.programs.git.enable = mkEnableOption "git";

  config = (
    mkIf cfg.enable {
      programs.git = {
        enable = true;
        lfs.enable = true;
        config = {
          user = {
            name = "Eddio0141";
            email = "eddio0141@gmail.com";
          };
          pull.rebase = false;
          init.defaultBranch = "main";
          advice.addIgnoredFile = false;
        };
      };
    }
  );
}
