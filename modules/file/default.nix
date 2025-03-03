{
  config,
  lib,
  username,
  relativePath,
  ...
}:
let
  cfg = config.yuu.file;
  mkOption = lib.mkOption;
  mapAttrsToList = lib.attrsets.mapAttrsToList;
in
{
  # TODO: the folders need to have user permission too
  options.yuu.file.home = mkOption {
    default = { };
  };

  config = {
    systemd.tmpfiles.rules = mapAttrsToList (
      dest: path: "L /home/${username}/${dest} - - - - ${config.programs.nh.flake + (relativePath path)}"
    ) cfg.home;
  };
}
