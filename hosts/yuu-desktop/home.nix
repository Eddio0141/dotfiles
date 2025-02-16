{ pkgs, ... }:
{
  systemd.user.services.noisetorch =
    let
      deviceUnit = ''sys-devices-pci0000:00-0000:00:08.1-0000:0a:00.3-usb3-3\x2d4-3\x2d4:1.0-sound-card4-controlC4.device'';
      deviceId = ''alsa_input.usb-Razer_Inc_Razer_Seiren_Mini_UC2220L03401755-00.mono-fallback'';
    in
    {
      Unit = {
        Description = "Noisetorch Noise Cancelling";
        Requires = deviceUnit;
        After = [
          deviceUnit
          "pipewire.service"
        ];
      };

      Service = {
        Type = "simple";
        RemainAfterExit = "yes";
        ExecStart = "${pkgs.lib.getExe pkgs.noisetorch} -i -s ${deviceId} -t 95";
        ExecStop = "${pkgs.lib.getExe pkgs.noisetorch} -u";
        Restart = "on-failure";
        RestartSec = 3;
      };

      Install = {
        WantedBy = "default.target";
      };
    };
}
