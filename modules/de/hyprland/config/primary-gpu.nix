{ cfg, lib, ... }:
let
  mkIf = lib.mkIf;
  concatStringsSep = lib.strings.concatStringsSep;
  using-gpus =
    if builtins.isList cfg.using-gpus && builtins.length cfg.using-gpus > 0 then
      cfg.using-gpus
    else if builtins.isString cfg.using-gpus then
      [ cfg.using-gpus ]
    else
      null;
in
{
  env = [
    (mkIf (!(builtins.isNull using-gpus))
      # gpu to use
      "AQ_DRM_DEVICES,${concatStringsSep ":" using-gpus}"
    )
  ];
}
