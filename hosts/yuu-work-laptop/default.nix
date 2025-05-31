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
  # TODO: many of the stuff can be modules, it comes from casual.nix
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/stylix.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen5
    inputs.niri.nixosModules.niri
    inputs.stylix.nixosModules.stylix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.loader.systemd-boot = {
    enable = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    networkmanager.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        libsForQt5.fcitx5-qt
      ];
      waylandFrontend = true;
    };
  };

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };

    # dbus for updating firmware
    fwupd.enable = true;

    automatic-timezoned.enable = true;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    playerctld.enable = true;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time";
          user = "greeter";
        };
      };
    };

    journald = {
      extraConfig = ''
        MaxRetentionSec=7day
      '';
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig."11-bluetooth-policy" = {
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
    };
  };

  home-manager.users.${username} = {
    home.stateVersion = "25.05";

    imports = [
      ../../modules/stylix-hm.nix
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    # kvm and libvirtd groups are needed for virt-manager
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "libvirtd"
      "docker"
      "power"
      "input"
      "storage"
      "video"
      "libvirt"
      "nix-users"
      "macisajt"
      "users"
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
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };

    ssh.startAgent = true;
    command-not-found.enable = false;
    java.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libGL
        libGLU
        fontconfig
        libxkbcommon
        freetype
        dbus
        wayland
        gtk3
        gtk2-x11
        pango
        atk
        cairo
        gdk-pixbuf
        glib
        nss
        nspr
        alsa-lib
        gnome2.GConf
        expat
        cups
        libcap
        fuse
        xorg.libX11
        xorg.libXext
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXi
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXfixes
        xorg.libXtst
        xorg.libXrender
        xorg.libxcb
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    btop-rocm
    obsidian
    xdg-utils
    libreoffice-qt
    # spell checking
    hunspell
    hunspellDicts.en_GB-large
    # external storage
    gvfs
    udisks
    # managing qt5 themes
    libsForQt5.qt5ct
  ];

  qt.platformTheme = "qt5ct";

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

  # fonts
  fonts.packages =
    with pkgs;
    [
      # basic stuff
      corefonts

      # japanese
      ipafont
      ipaexfont
      kochi-substitute

      # emojis
      openmoji-color
      noto-fonts-emoji
    ]
    ++ (with pkgs.nerd-fonts; [
      code-new-roman
      jetbrains-mono
    ]);
  fonts.fontDir.enable = true;

  system.stateVersion = "25.05";

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://colmena.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      ];
      access-tokens = builtins.getEnv "NIX_ACCESS_TOKENS";
    };
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  # services.tumbler.enable = true; # Thumbnail support for images

  # polkit
  security.polkit.enable = true;

  programs.dconf.enable = true;

  environment.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "/home/${username}/Pictures/screenshots";
    XKB_DEFAULT_LAYOUT = "gb";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  xdg.portal.xdgOpenUsePortal = true;

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  yuu = {
    programs = {
      ghidra.uiScale = 1.5;
      git = {
        enable = true;
        config = {
          user = null;
        };
      };
      nvim.enable = true;
      gpu-screen-recorder.enable = true;
      fastfetch.customArt = false;
    };
    pack.comfy-shell.enable = true;
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
      # vial devices
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

        # disable / enable laptop keyboard on split kb connect
        # check https://blog.hackeriet.no/udev-disable-keyboard
        ATTRS{name}=="${externalKbName}", ACTION=="add", RUN+="${lib.getExe disableLaptopKb}"
        ATTRS{name}=="${externalKbName}", ACTION=="remove", RUN+="${lib.getExe enableLaptopKb}"
    '';
}
