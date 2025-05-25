{
  username,
  pkgs,
  inputs,
  system,
  lib,
  ...
}:
let
  laptopKbDevice = ''"$(rg -U '^N: Name="Framework Laptop 16 Keyboard Module - ISO Keyboard"\n.*\nS: Sysfs=(.*$)' -or '/sys$1/inhibited' '/proc/bus/input/devices')"'';
  disableLaptopKb = pkgs.writeShellApplication {
    name = "disableLaptopKb";
    runtimeInputs = with pkgs; [
      ripgrep
    ];
    text = ''
      echo 1 > ${laptopKbDevice}
    '';
  };
  enableLaptopKb = pkgs.writeShellApplication {
    name = "enableLaptopKb";
    runtimeInputs = with pkgs; [
      ripgrep
    ];
    text = ''
      echo 0 > ${laptopKbDevice}
    '';
  };
in
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
    de.hyprland.xwaylandScale = 2;
    programs.ghidra.uiScale = 1.5;
    # pack.dri-prime.enable = true;
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "inputmodule-rs-udev";
      text = builtins.readFile ./50-framework-inputmodule.rules;
      destination = "/etc/udev/rules.d/50-framework-inputmodule.rules";
    })
  ];

  services.udev.extraRules =
    let
      externalKbName = "splitkb.com Aurora Lily58 rev1";
    in
    ''
      # disable / enable laptop keyboard on split kb connect
      # check https://blog.hackeriet.no/udev-disable-keyboard
      ATTRS{name}=="${externalKbName}", ACTION=="add", RUN+="${lib.getExe disableLaptopKb}"
      ATTRS{name}=="${externalKbName}", ACTION=="remove", RUN+="${lib.getExe enableLaptopKb}"
    '';
}
