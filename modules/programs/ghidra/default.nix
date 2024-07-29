{ config, pkgs, lib, ... }:
let
  cfg = config.yuu.programs.ghidra;
  mkEnableOption = lib.mkEnableOption;
  mkIf = lib.mkIf;
  mkOption = lib.mkOption;
in
{
  options.yuu.programs.ghidra = {
    enable = mkEnableOption "ghidra";
    uiScale = mkOption {
      default = null;
    };
  };

  config = (mkIf cfg.enable {
    environment.systemPackages =
      let
        scaleUi =
          if isNull cfg.uiScale then
            ""
          else
            ''
              substituteInPlace "$out/lib/ghidra/support/launch.properties" \
                --replace-fail "uiScale=1" "uiScale=${toString cfg.uiScale}"
            '';
      in
      with pkgs; [
        (ghidra.overrideAttrs (prev: {
          postFixup = (''
            substituteInPlace "$out/lib/ghidra/ghidraRun" \
              --replace-fail "#MAXMEM=2G" "MAXMEM=20G"
          ''
          + scaleUi
          + prev.postFixup);
        }))
      ];
  });
}
