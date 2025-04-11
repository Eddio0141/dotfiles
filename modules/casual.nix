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
    text =
      (if config.yuu.pack.dri-prime.enable then "export DRI_PRIME=1" else "")
      + ''
        # shellcheck disable=SC2163
        gamemoderun "$@"
      '';
  };
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./stylix.nix
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
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "dotnet-sdk-7.0.410"
        "dotnet-sdk-wrapped-7.0.410"
      ];
    };
  };

  time.timeZone = "Europe/London";

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Select internationalisation properties.
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

    # TODO: shit aint working
    # automatic-timezoned.enable = true;

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

  # Enable CUPS to print documents.
  #services.printing.enable = true;

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

  programs = {
    ssh.startAgent = true;
    command-not-found.enable = false;
    noisetorch.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-webkitgtk
      ];
    };
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJIe9xUjQ2cvylpFcYh7BCqIcMGnHuThTjNgYC71CinB yuu@yuu-laptop"
    ];
  };

  environment.systemPackages = with pkgs; [
    avalonia-ilspy
    btop-rocm
    obsidian
    (jetbrains.plugins.addPlugins jetbrains.rider [ "ideavim" ])
    protontricks
    xdg-utils
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
    thunderbird
    # blender
    ani-cli
    qbittorrent
    # davinci-resolve
    yt-dlp
    strawberry-qt6
    r2modman
    # libtas
    # (gimp-with-plugins.override { plugins = with gimpPlugins; [ gap ]; })
    wl-clipboard
    cliphist
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
    file
    # binaryninja-free
    imhex
    steam-game-wrap
    inputs.umu.packages.${system}.default
    vesktop
    pinta
    floorp
    ripgrep
    mpv
    wofi
    pamixer # volume control

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

  programs = {
    java.enable = true;
    steam.enable = true;
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

  nix = {
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
      # TODO: hide if public
      access-tokens = "github.com=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";
    };
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

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # polkit
  security.polkit.enable = true;

  # virtualisation.waydroid.enable = true;

  programs.dconf.enable = true;

  # env vars
  environment.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "/home/${username}/Pictures/screenshots";
    XKB_DEFAULT_LAYOUT = "gb";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # services.sunshine = {
  #   enable = true;
  #   capSysAdmin = true;
  #   openFirewall = true;
  # };

  programs.gamemode.enable = true;

  # TODO: restore
  # hardware.logitech = {
  #   lcd.enable = true;
  #   wireless = {
  #     enable = true;
  #     enableGraphical = true;
  #   };
  # };

  xdg.portal.xdgOpenUsePortal = true;

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "vial-udev";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
      destination = "/etc/udev/rules.d/99-vial.rules";
    })
  ];

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
