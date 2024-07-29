{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.yuu.programs.gpu-screen-recorder;
in
{
  options.yuu.programs.gpu-screen-recorder = {
    enable = mkEnableOption "gpu-screen-recorder";
    # TODO: FIX
    # service = {
    #   enable = mkEnableOption "gpu-screen-recorder service";
    #   # TODO: does it work with record as well
    #   screen = mkOption { type = types.str; };
    #   # TODO: make it check path
    #   # save-dir = mkOption { type = types.path; };
    #   save-dir = mkOption { type = types.str; };
    # };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # overlays
      nixpkgs.overlays = [
        (self: super: {
          gpu-screen-recorder = super.gpu-screen-recorder.overrideAttrs (old: {
            postInstall = ''
              install -Dt $out/bin gpu-screen-recorder gsr-kms-server
              mkdir $out/bin/.wrapped
              mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
              makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
              --prefix LD_LIBRARY_PATH : ${self.libglvnd}/lib \
              --suffix PATH : $out/bin
            ''; # prefix -> suffix
          });
          gpu-screen-recorder-gtk = super.gpu-screen-recorder-gtk.overrideAttrs (old: {
            installPhase = ''
              install -Dt $out/bin/ gpu-screen-recorder-gtk
              install -Dt $out/share/applications/ gpu-screen-recorder-gtk.desktop
              gappsWrapperArgs+=(--prefix PATH : /run/wrappers/bin:${super.lib.makeBinPath [ self.gpu-screen-recorder ]})
              # gappsWrapperArgs+=(--prefix PATH : /run/wrappers/bin)
              # we also append /run/opengl-driver/lib as it otherwise fails to find libcuda.
              gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${super.lib.makeLibraryPath [ self.libglvnd ]}:/run/opengl-driver/lib)
            ''; # add /run/wrappers/bin to prefix
          });
        })
      ];

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
