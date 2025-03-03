{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.yuu.programs.dunst;
in
{
  options.yuu.programs.dunst.enable = lib.mkEnableOption "dunst";

  config = (
    lib.mkIf cfg.enable {
      # yuu.file.home.config."dunst/dunstrc" = ./dunstrc;

      home-manager.users.${username}.services.dunst = {
        enable = true;
        settings = {
          global = {
            follow = "keyboard";
          };
        };
        # configFile = ./dunstrc;
      };
    }
  );
}
