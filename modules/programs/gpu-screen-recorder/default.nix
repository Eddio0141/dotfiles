{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.yuu.programs.gpu-screen-recorder;
in
{
  options.yuu.programs.gpu-screen-recorder = {
    enable = mkEnableOption "gpu-screen-recorder";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        gpu-screen-recorder-gtk
      ];

      programs.gpu-screen-recorder.enable = true;
    })
    # (mkIf cfg.service.enable {
    #   systemd.user.services.gpu-screen-recorder = {
    #     description = "gpu-screen-recorder";
    #     wantedBy = [ "graphical-session.target" ];
    #     wants = [ "graphical-session.target" ];
    #     after = [ "graphical-session.target" ];
    #     path = with pkgs; [
    #       gpu-screen-recorder
    #       pulseaudio
    #       (lib.getBin config.security.wrapperDir)
    #     ];
    #     serviceConfig = {
    #       ExecStart = pkgs.writeShellScript "start-gpu-screen-recorder" ''
    #         AUDIO="$(pactl get-default-sink).monitor";
    #         exec gpu-screen-recorder \
    #           -w ${cfg.service.screen} \
    #           -c mp4 \
    #           -f 60 \
    #           -a "$AUDIO" \
    #           -q very_high \
    #           -r 30 \
    #           -k h264 \
    #           -v no \
    #           -mf yes \
    #           -o "${cfg.service.save-dir}"
    #       '';
    #       Restart = "on-failure";
    #       RestartSec = 5;
    #       KillSignal = "SIGINT";
    #     };
    #   };
    # })
  ];

}
