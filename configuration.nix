# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, inputs, system, self, ... }:

{
  # TODO rewrite this shit

  imports =
    [ # Include the results of the hardware scan.
      #./hardware-configuration.nix
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
    hostName = "${username}"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Set your time zone.
  time.timeZone = "Europe/London";

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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm = {
    enable = true;
    # wayland.enable = true;
    # theme = "${pkgs.sddm-chili-theme}/share/sddm/themes/chili";
  };
  #services.xserver.desktopManager.plasma5.enable = true;

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
  sound.enable = true;
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

  programs.noisetorch.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    # kvm and libvirtd groups are needed for virt-manager
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "docker" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlay
  ];

  environment.systemPackages = with pkgs; [
    firefox
    kate
    vesktop
    avalonia-ilspy
    neofetch
    btop
    git
    obsidian
    obs-studio
    (jetbrains.plugins.addPlugins jetbrains.rider [
      "github-copilot"
      "ideavim"
    ])
    p7zip
    protontricks
    xdg-utils
    # distrobox
    webcord
    wineWowPackages.staging
    winetricks
    libreoffice-qt
    # TODO wrap unityhub to launch with DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    (pkgs.unityhub.override {
      extraLibs = pkgs: with pkgs; [
        openssl_1_1
        dotnet-sdk_7
      ];
    })
    gamemode
    ffmpeg
    lutris
    thunderbird
    blender
    ani-cli
    qbittorrent
    #davinci-resolve
    yt-dlp
    clementine
    pkgsi686Linux.gperftools # TODO remove when tf2 is fixed, also update tf2's launch options after
    r2modman
    inputs.gpt4all.packages.${system}.gpt4all-chat
    libtas
    # https://nixos.org/manual/nixpkgs/unstable/#sec-fhs-environments
    (buildFHSEnv (
       appimageTools.defaultFhsEnvArgs //
    {
      name = "fhs-env";
      multiArch = true;
      runScript = "zsh";
    }))
    (gimp-with-plugins.override { plugins = with gimpPlugins; [
      gap
    ];})
    wl-clipboard
    cliphist
    quickemu
    upwork

    # spell checking
    hunspell
    hunspellDicts.en_GB-large

    # vm stuff
    virt-manager

    # hypr stuff
    mpv
    kitty
    wofi
    # TODO merge this into grimblast
    inputs.hyprpicker.packages.${system}.default
    inputs.hyprcontrib.packages.${system}.grimblast
    libsForQt5.gwenview
    pamixer # volume control
    hyprpaper

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

    # sddm theme TODO for hyprland only
    sddm-chili-theme
  ];

  qt.platformTheme = "qt5ct";

  # insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
    "openssl-1.1.1w"
    "electron-25.9.0"
  ];

  # java
  programs.java.enable = true;

  # steam
  programs.steam.enable = true;

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

  # vulkan
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  # fonts
  fonts.packages = with pkgs; [
    # japanese
    ipafont
    kochi-substitute

    # other stuff
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    corefonts
    jetbrains-mono

    # idk what those are
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts

    # for waybar TODO
    (nerdfonts.override {
      fonts = [ "CodeNewRoman" ];
    })
  ];

  # gc
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  nix.settings.auto-optimise-store = true;

  # zsh
  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;

  environment.shells = [ pkgs.zsh ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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

  security.sudo.wheelNeedsPassword = false;

  services.syncthing = {
    user = "${username}";
    group = "wheel";
    dataDir = "/home/${username}/.config/syncthing";
    openDefaultPorts = true;
    settings = {
      devices = {
        mobile = {
          id = "ZOW4POS-N3SKSZ5-ECM6NB7-ICMENDW-LRYONHP-CPXJNHI-BU77TE5-T6W2MQM";
        };
        laptop = {
          id = "XTDP5I6-5NPJXNL-CQIYBAP-TN75VCX-37RWFBV-YAJSB6X-6URZYEN-HG7EJQP";
        };
      };
      extraOptions = {
        startBrowser = false;
        urAccepted = -1;
      };
      folders = {
        "/home/${username}/Documents/Obsidian" = {
          id = "obsidian";
          devices = [ "mobile" "laptop" ];
        };
        "/home/${username}/sync" = {
          id = "sync";
          devices = [ "mobile" "laptop" ];
        };
        "/home/${username}/Music" = {
          id = "music";
          devices = [ "mobile" "laptop" ];
        };
      };
    };
    enable = true;
  };

  # thunar stuff
  # programs.thunar = {
  #   enable = true;
  #   plugins = with pkgs.xfce; [
  #     thunar-volman
  #     thunar-archive-plugin
  #     thunar-media-tags-plugin
  #   ];
  # };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # polkit
  security.polkit.enable = true;

  virtualisation.waydroid.enable = true;

  # podman for distrobox
  # virtualisation.podman.enable = true;

  # for virt-manager
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = true;
      ovmf.enable = true;
      verbatimConfig = ''
        user = "${username}"
        group = "kvm"
        namespaces = []
      '';
    };
  };

  programs.dconf.enable = true;

  # env vars
  environment.sessionVariables = {
    # TODO fix this
    # GTK_IM_MODULE = "";
    XDG_SCREENSHOTS_DIR = "/home/${username}/Pictures/screenshots";
  };

  services.teamviewer.enable = true;

  # services.flatpak.enable = true;

  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableBrowserSocket = true;
    enableExtraSocket = true;
    enableSSHSupport = true;
  };

  # programs.sway = {
  #   enable = true;
  #   package = pkgs.swayfx;
  # };
  
  de.hyprland.enable = true;
}

