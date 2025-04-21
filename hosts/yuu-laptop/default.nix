{
  username,
  pkgs,
  inputs,
  system,
  lib,
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
