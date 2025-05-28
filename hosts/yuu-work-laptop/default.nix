{
  username,
  pkgs,
  inputs,
  system,
  lib,
  ...
}:
let
  # TODO: copied from yuu-laptop/default.nix, should merge
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
    ./hardware-configuration.nix
    ../../modules
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen5
    inputs.niri.nixosModules.niri
  ];

  home-manager.users.${username} = {
    imports = [
    ];
  };

  # for work, username for consistency
  networking.hostName = username;

  services = {
    blueman.enable = true;
    quassel = {
      enable = true;
      user = "edcope";
    };
  };

  programs = {
    # wifi menu
    nm-applet.enable = true;

    firefox.enable = true;
    thunderbird = {
      enable = true;
      # TODO: copied from casual.nix
      preferences = { "widget.use-xdg-desktop-portal.file-picker" = 1; };
    };
  };

  yuu = {
    programs.ghidra.uiScale = 1.5;
    de.niri.enable = true;
    # pack.dri-prime.enable = true;
  };

  # TODO: this is also shared from yuu-laptop
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
