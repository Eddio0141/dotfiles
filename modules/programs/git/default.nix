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
      programs = {
        git = {
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
            url = {
              "git@github.com:".insteadOf = [
                "https://github.com/"
              ];
              "git@gitlab.com:".insteadOf = [
                "https://gitlab.com/"
              ];
              "git@gitlab.codethink.co.uk:".insteadOf = [
                "https://gitlab.codethink.co.uk/"
              ];
            };
          } // cfg.config;
        };
        lazygit.enable = true;
      };
    }
  );
}
