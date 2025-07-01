# contains shared goodies like theming, nix settings, etc
{
  lib,
  inputs,
  pkgs,
  username,
  pkgs-stable,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfree = lib.mkDefault true;
    };

    overlays = [
      (_: _: {
        # TODO: remove me when unityhub builds
        gnome2.GConf = pkgs-stable.gnome2.GConf;
      })
    ];
  };

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

  xdg.portal.xdgOpenUsePortal = true;

  environment = {
    sessionVariables = {
      XKB_DEFAULT_LAYOUT = "gb";
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    systemPackages = with pkgs; [
      btop-rocm
      xdg-utils
      file
      ripgrep
      mpv
      ## spell checking
      hunspell
      hunspellDicts.en_GB-large
      ##
      udisks
      libsForQt5.qt5ct # managing qt5 themes
    ];
  };

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
      trusted-users = [
        "root"
        username
      ];
      access-tokens = builtins.getEnv "NIX_ACCESS_TOKENS";
    };
    channel.enable = false;
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  qt.platformTheme = "qt5ct";

  programs = {
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
    firefox.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
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

  services = {
    xserver.enable = true; # TODO: do i need this

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

  networking.networkmanager.enable = true;

  programs.command-not-found.enable = false;

  # audio
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

  # keymap
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  console.keyMap = "uk";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
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
  };

  # input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc-ut
        fcitx5-gtk
        libsForQt5.fcitx5-qt
      ];
      waylandFrontend = true;
    };
    enableGtk2 = true;
    enableGtk3 = true;
  };
}
