{
  username,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/casual.nix
    ./hardware-configuration.nix
    ../../modules
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    inputs.niri.nixosModules.niri
  ];

  home-manager.users.${username} = {
    imports = [
      ../../modules/casual-home.nix
    ];

    programs.niri.settings.outputs.eDP-2.variable-refresh-rate = true;
    wayland.windowManager.hyprland.settings.monitor = [ "eDP-2, 2560x1600@165, 0x0, 1.6, vrr,1" ];
  };

  networking.hostName = "${username}-laptop";

  services.blueman.enable = true;

  # wifi menu
  programs.nm-applet.enable = true;

  yuu = {
    de = {
      niri.enable = true;
      hyprland.xwaylandScale = 2;
    };
    programs.ghidra.uiScale = 2;
    pack.dri-prime.enable = true;
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "inputmodule-rs-udev";
      text = builtins.readFile ./50-framework-inputmodule.rules;
      destination = "/etc/udev/rules.d/50-framework-inputmodule.rules";
    })
  ];
}
