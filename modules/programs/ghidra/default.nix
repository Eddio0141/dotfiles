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
  scaleUi = if isNull cfg.uiScale then "" else "; s,uiScale=1,uiScale=${toString cfg.uiScale},g";
  pathAdd = with pkgs; [
    lldb
    (python3.withPackages (
      p: with p; [
        psutil
        protobuf
      ]
    ))
  ];
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
        (pkgs.runCommand "ghidra"
          {
            nativeBuildInputs = with pkgs; [ makeBinaryWrapper ];
          }
          ''
            mkdir -p "$out"
            cp -r "${pkgs.ghidra}"/* "$out/"
              chmod -R +w "$out"
              makeWrapper "$out/lib/ghidra/support/.launch.sh-wrapped" "$out/lib/ghidra/support/launch.sh" \
                --inherit-argv0 \
                --set-default NIX_GHIDRAHOME "$out/lib/ghidra/Ghidra" \
                --prefix PATH : ${lib.makeBinPath ([ pkgs.openjdk21 ] ++ pathAdd)}
              sed -i 's,#MAXMEM=2G,MAXMEM=20G,g${scaleUi}' "$out/lib/ghidra/support/launch.properties"
          ''
        )
      ];
    }
  );
}
