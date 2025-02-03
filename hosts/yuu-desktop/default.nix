{
  username,
  ...
}:
{
  imports = [
    ../../modules/casual.nix
    ./hardware-configuration.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../modules/casual-home.nix
    ];

    programs.niri.settings.outputs = {
      "DP-3".position = {
        x = 0;
        y = 0;
      };
    };
  };

  networking.hostName = "yuu-desktop";

  yuu.de = {
    hyprland = {
      monitors = [
        "DP-3, 1920x1080@144, 0x0, 1"
        "HDMI-A-1, 1920x1080@60, 1920x0, 1"
      ];
      exec-once = [
        "steam -silent"
      ];
    };
    niri.enable = true;
  };
}
