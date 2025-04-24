{
  username,
  pkgs,
  inputs,
  system,
  lib,
  ...
}:
let
  externalKbName = "splitkb.com Aurora Lily58 rev1";
  laptopKbDevice = "/sys/devices/pci0000:00/0000:00:08.1/0000:c5:00.3/usb1/1-4/1-4.2/1-4.2:1.2/0003:32AC:0018.000C/input/input24/inhibited";
  disableLaptopKb = pkgs.writeShellApplication {
    name = "disableLaptopKb";
    text = ''
      echo 1 > ${laptopKbDevice}
    '';
  };
  enableLaptopKb = pkgs.writeShellApplication {
    name = "enableLaptopKb";
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

  services.udev.extraRules = ''
    # disable / enable laptop keyboard on split kb connect
    # check https://blog.hackeriet.no/udev-disable-keyboard
    ATTRS{name}=="${externalKbName}", ACTION=="add", RUN+="${lib.getExe disableLaptopKb}"
    ATTRS{name}=="${externalKbName}", ACTION=="remove", RUN+="${lib.getExe enableLaptopKb}"
  '';

  # HACK: downgrade mesa to 24
  # https://www.reddit.com/r/framework/comments/1jbqr56/dying_igpu/
  # https://community.frame.work/t/screen-is-glitchy-with-colored-pixels-moving-on-fedora-41-laptop-13-amd-ryzen-7040/66117/1
  hardware.graphics = {
    package = inputs.nixpkgs-mesa.legacyPackages.${system}.mesa.drivers;
    package32 = inputs.nixpkgs-mesa.legacyPackages.${system}.driversi686Linux.mesa.drivers;
  };

  system.replaceDependencies.replacements = [
    {
      oldDependency = pkgs.mesa.out;
      newDependency = inputs.nixpkgs-mesa.legacyPackages.${system}.mesa.out;
    }
    {
      oldDependency = pkgs.pkgsi686Linux.mesa.out;
      newDependency = inputs.nixpkgs-mesa.legacyPackages.${system}.pkgsi686Linux.mesa.out;
    }
  ];
}
