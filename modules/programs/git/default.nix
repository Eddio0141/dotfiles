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
  # TODO: config option
  options.yuu.programs.git = {
    enable = mkEnableOption "git";
    config = mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

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
        } // cfg.config;
      };
    }
  );
}
