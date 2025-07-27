# module for a casual desktop

{
  pkgs,
  username,
  inputs,
  system,
  config,
  ...
}:
let
  # for steam games
  steam-game-wrap = pkgs.writeShellApplication {
    name = "steam-game-wrap";
    runtimeInputs = [ pkgs.gamemode ];
    text = (if config.yuu.pack.dri-prime.enable then "export DRI_PRIME=1" else "") + ''
      # shellcheck disable=SC2163
      gamemoderun "$@"
    '';
  };
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./stylix.nix
    ./shared.nix
  ];

  nixpkgs = {
    overlays = [
      # fixes 32 bit source games not launching
      # NOTE: https://github.com/NixOS/nixpkgs/issues/271483
      (final: prev: {
        steam = prev.steam.override (
          {
            extraLibraries ? pkgs': [ ],
            ...
          }:
          {
            extraLibraries = pkgs': (extraLibraries pkgs') ++ [ pkgs'.gperftools ];
          }
        );
      })
    ];

    config = {
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "dotnet-sdk-7.0.410"
        "dotnet-sdk-wrapped-7.0.410"
      ];
    };
  };

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services = {
    # TODO: needed? TODO: not nvidia friendly?
    xserver.videoDrivers = [ "amdgpu" ];
  };

  programs = {
    noisetorch.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-webkitgtk
      ];
    };
    thunderbird.enable = true;
  };

  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJIe9xUjQ2cvylpFcYh7BCqIcMGnHuThTjNgYC71CinB yuu@yuu-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpFCCYta1vyxj5f+Dg7SS3HduBXo6GmIZFcwDHnZ/cC yuu@yuu-desktop"
    ];
  };

  environment.systemPackages = with pkgs; [
    avalonia-ilspy
    obsidian
    (jetbrains.plugins.addPlugins jetbrains.rider [ "ideavim" ])
    wineWowPackages.full
    samba4Full
    winetricks
    libreoffice-qt
    # TODO wrap unityhub to launch with DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    (unityhub.override {
      extraLibs =
        pkgs: with pkgs; [
          openssl_1_1
          dotnet-sdk_7
        ];
    })
    ffmpeg
    lutris
    # blender
    ani-cli
    qbittorrent
    # davinci-resolve
    yt-dlp
    (rmpc.overrideAttrs (
      final: prev: {
        src = inputs.rmpc;
        version = "unstable";
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = final.src + "/Cargo.lock";
          allowBuiltinFetchGit = true;
        };
        cargoHash = null;
      }
    ))
    r2modman
    # libtas
    # (gimp-with-plugins.override { plugins = with gimpPlugins; [ gap ]; })
    quickemu
    # inputs.nixpkgs-godot-4.legacyPackages.${system}.godot_4
    # (godot_4.overrideAttrs rec {
    #   version = "4.1.1-stable";
    #   commitHash = "bd6af8e0ea69167dd0627f3bd54f9105bda0f8b5";
    #   src = fetchFromGitHub {
    #     owner = "godotengine";
    #     repo = "godot";
    #     rev = commitHash;
    #     hash = "sha256-0CErsMTrBC/zYcabAtjYn8BWAZ1HxgozKdgiqdsn3q8=";
    #   };
    # })
    # inputs.nixpkgs-citra-yuzu-temp.legacyPackages.${system}.yuzu-early-access
    # citra-canary
    # slack
    prismlauncher
    # binaryninja-free
    imhex
    steam-game-wrap
    inputs.umu.packages.${system}.default
    vesktop
    pinta
    wofi
    vial
    krita
    keepassxc
  ];

  programs = {
    java.enable = true;
    steam = {
      enable = true;
      protontricks.enable = true;
    };
  };

  # systemd.tmpfiles.rules =
  #   let
  #     rocmEnv = pkgs.symlinkJoin {
  #       name = "rocm-combined";
  #       paths = with pkgs.rocmPackages; [
  #         rocblas
  #         hipblas
  #         clr
  #       ];
  #     };
  #   in
  #   [
  #     "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  #   ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # OpenCL
      rocmPackages.clr.icd

      # vulkan
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      # vulkan 32 bit apps
      driversi686Linux.amdvlk
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # polkit
  security.polkit.enable = true;

  # virtualisation.waydroid.enable = true;

  programs.dconf.enable = true;
  programs.gamemode.enable = true;

  # TODO: restore
  # hardware.logitech = {
  #   lcd.enable = true;
  #   wireless = {
  #     enable = true;
  #     enableGraphical = true;
  #   };
  # };

  # TODO: introduce module for splitkb
  services.udev.extraRules = ''
    # vial devices
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  yuu = {
    de.niri.enable = true;
    programs = {
      git.enable = true;
      nvim.enable = true;
      gpu-screen-recorder.enable = true;
      ghidra.enable = true;
    };
    pack.comfy-shell.enable = true;
    services.syncthing.enable = true;

    # for ideavim
    file.home.".ideavimrc" = ./ideavimrc.vim;
  };
}
