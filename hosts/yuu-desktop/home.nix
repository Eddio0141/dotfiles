{ pkgs, ... }:
{
  systemd.user.services.noisetorch =
    let
      deviceId = ''alsa_input.usb-Razer_Inc_Razer_Seiren_Mini_UC2220L03401755-00.mono-fallback'';
    in
    {
      Unit = {
        Description = "Noisetorch Noise Cancelling";
        Requires = "pipewire.socket";
        StartLimitIntervalSec = 35;
        StartLimitBurst = 9;
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
        WantedBy = [ "default.target" ];
      };
    };
}
