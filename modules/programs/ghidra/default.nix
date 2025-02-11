{
  config,
  pkgs,
  lib,
  ...
}:
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

  config = (
    mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.symlinkJoin {
          name = "ghidra";
          paths = [ pkgs.ghidra ];
          postBuild =
            let
              scaleUi =
                if isNull cfg.uiScale then
                  ""
                else
                  ''
                    source="$out/lib/ghidra/support/launch.properties"
                    ${replace-source-with-readlink}

                    substituteInPlace "$source" \
                      --replace-fail "uiScale=1" "uiScale=${toString cfg.uiScale}"
                  '';
              replace-source-with-readlink = ''
                target=$(readlink -f "$source")
                rm $source
                cp "$target" "$source"
              '';
            in
            ''
              source="$out/lib/ghidra/ghidraRun"
              ${replace-source-with-readlink}

              substituteInPlace "$source" \
                --replace-fail "#MAXMEM=2G" "MAXMEM=20G"
            ''
            + scaleUi;
        })
      ];
    }
  );
}
