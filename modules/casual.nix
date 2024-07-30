# module for a casual desktop

{ config, pkgs, username, inputs, system, self, pkgs-stable, own-pkgs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./stylix.nix
  ];

  time.timeZone = "Europe/London";

  # TODO rewrite this shit
  nixpkgs.overlays = [
    # fixes 32 bit source games not launching
    # TODO: issue to be tracked needs to be put here
    (final: prev: {
      steam = prev.steam.override ({ extraLibraries ? pkgs': [ ], ... }: {
        extraLibraries = pkgs': (extraLibraries pkgs') ++ [
          pkgs'.gperftools
        ];
      });
    })
  ];

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
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      libsForQt5.fcitx5-qt
    ];
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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  programs = {
    ssh.startAgent = true;
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
      ];
    };
    command-not-found.enable = false;
    noisetorch.enable = true;
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    # kvm and libvirtd groups are needed for virt-manager
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "docker" ];
  };

  environment.systemPackages = with pkgs; [
    firefox
    vesktop
    avalonia-ilspy
    btop
    obsidian
    (jetbrains.plugins.addPlugins jetbrains.rider [
      "ideavim"
    ])
    p7zip
    protontricks
    xdg-utils
    wineWowPackages.staging
    winetricks
    libreoffice-qt
    # TODO wrap unityhub to launch with DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    (unityhub.override {
      extraLibs = pkgs: with pkgs; [
        openssl_1_1
        dotnet-sdk_7
      ];
    })
    ffmpeg
    lutris
    thunderbird
    blender
    ani-cli
    miru
    qbittorrent
    #davinci-resolve
    yt-dlp
    clementine
    r2modman
    libtas
    (gimp-with-plugins.override {
      plugins = with gimpPlugins; [
        gap
      ];
    })
    wl-clipboard
    cliphist
    quickemu
    (godot_4.overrideAttrs rec {
      version = "4.1.1-stable";
      commitHash = "bd6af8e0ea69167dd0627f3bd54f9105bda0f8b5";
      src = fetchFromGitHub {
        owner = "godotengine";
        repo = "godot";
        rev = commitHash;
        hash = "sha256-0CErsMTrBC/zYcabAtjYn8BWAZ1HxgozKdgiqdsn3q8=";
      };
    })
    inputs.nixpkgs-citra-yuzu-temp.legacyPackages.${system}.yuzu-early-access
    # citra-canary
    slack
    gnome.gnome-calculator
    aw-qt # TODO make this a service with proper env variables (test with empty env and you will see whats missing)
    # (ghidra-bin.overrideAttrs {
    #   # buildInputs = [
    #   #   # for debugging
    #   #   python3Packages.psutil
    #   #   python3Packages.protobuf3
    #   #   lldb
    #   #   gdb
    #   # ];
    #   postFixup =
    #     let
    #       pkg_path = "$out/lib/ghidra";
    #     in
    #     ''
    #       mkdir -p "$out/bin"
    #       ln -s "${pkg_path}/ghidraRun" "$out/bin/ghidra"
    #
    #       wrapProgram "${pkg_path}/support/launch.sh" \
    #         --prefix PATH : ${lib.makeBinPath [
    #           openjdk17
    #           (python3.withPackages (p: with p; [
    #             psutil
    #             protobuf3
    #           ]))
    #           lldb
    #           gdb
    #         ]}
    #     '';
    # })
    prismlauncher
    file

    # spell checking
    hunspell
    hunspellDicts.en_GB-large

    # hypr stuff
    mpv
    wofi
    # TODO merge this into grimblast
    inputs.hyprpicker.packages.${system}.default
    inputs.hyprcontrib.packages.${system}.grimblast
    libsForQt5.gwenview
    pamixer # volume control

    # external storage
    gvfs
    udisks

    # dolphin
    libsForQt5.kio-extras
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.kdegraphics-thumbnailers
    ffmpegthumbnailer
    libsForQt5.kimageformats
    libheif
    libsForQt5.qt5.qtimageformats
    resvg
    libsForQt5.ffmpegthumbs
    taglib
    libsForQt5.breeze-qt5
    libsForQt5.breeze-icons
    libsForQt5.ark

    # managing qt5 themes
    libsForQt5.qt5ct
  ];

  qt.platformTheme = "qt5ct";

  programs = {
    java.enable = true;
    steam.enable = true;
  };

  systemd = {
    # HIP
    tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };

  hardware.opengl.extraPackages = with pkgs; [
    # OpenCL
    rocm-opencl-icd
    rocm-opencl-runtime

    # vulkan
    amdvlk
  ];

  hardware.opengl.extraPackages32 = with pkgs; [
    # vulkan 32 bit apps
    driversi686Linux.amdvlk
  ];

  # fonts
  fonts.packages = with pkgs; [
    # basic stuff
    corefonts

    # japanese
    ipafont
    ipaexfont
    kochi-substitute

    # code stuff
    (nerdfonts.override {
      fonts = [
        "CodeNewRoman"
        "JetBrainsMono"
      ];
    })

    # emojis
    openmoji-color
    noto-fonts-emoji
  ];
  fonts.fontDir.enable = true;

  nix.settings = {
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
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
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
    # TODO fix this
    # GTK_IM_MODULE = "";
    XDG_SCREENSHOTS_DIR = "/home/${username}/Pictures/screenshots";
  };

  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.gamemode.enable = true;

  yuu = {
    de = {
      hyprland = {
        enable = true;
        brightness-change = true;
      };
      # sway.enable = true;
    };
    programs = {
      git.enable = true;
      nvim.enable = true;
      gpu-screen-recorder.enable = true;
      ghidra.enable = true;
    };
    pack.comfy-shell.enable = true;
    services.syncthing.enable = true;
  };
}

