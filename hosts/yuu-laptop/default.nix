{ username, inputs, pkgs, ... }:
{
  imports = [
    ../../modules/casual.nix
    ./hardware-configuration.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../modules/casual-home.nix
      inputs.hyprland.homeManagerModules.default
    ];
  };

  networking.hostName = "yuu-laptop";

  services.blueman.enable = true;

  # wifi menu
  programs.nm-applet.enable = true;

  yuu = {
    de.hyprland = {
      xwaylandScale = 2;
      monitors = [
        "eDP-2, 2560x1600@165, 0x0, 1.6, vrr,1"
      ];
    };
    programs.ghidra.uiScale = 2;
    # programs.gpu-screen-recorder.service = {
    #   enable = true;
    #   screen = "eDP-1";
    #   save-dir = "/home/yuu/Videos";
    # };
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "inputmodule-rs-udev";
      text = builtins.readFile ./50-framework-inputmodule.rules;
      destination = "/etc/udev/rules.d/50-framework-inputmodule.rules";
    })
  ];
}
