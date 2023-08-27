# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, inputs, ... }:

{
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

  networking.hostName = "${username}"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
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
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    kate
    discord-canary
    vim
    avalonia-ilspy
    neofetch
    btop
    git
    obsidian
    obs-studio
    vscode
    jetbrains.rider
    github-copilot-intellij-agent
    p7zip
    protontricks
    xdg-utils
    distrobox
    webcord
    wine
    wine64
    winetricks
    libreoffice-qt
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

    # hypr stuff
    pavucontrol
    mpv
    dunst
    kitty
    wofi
    inputs.hyprcontrib.packages.${pkgs.system}.grimblast
    hyprpicker # this is needed for grimblast
    libsForQt5.gwenview

    # external storage
    gvfs
    udisks

    # dolphin
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.kdegraphics-thumbnailers
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

  # insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      discord-canary = prev.discord.overrideAttrs (_: {
        src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "0pml1x6pzmdp6h19257by1x5b25smi2y60l1z40mi58aimdp59ss";
        };
      });
    })
  ];

  # java
  programs.java.enable = true;

  # steam
  programs.steam.enable = true;

  # HIP
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

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

    # for waybar
    font-awesome

    corefonts
    jetbrains-mono
  ];

  # gc
  nix.gc = {
    automatic = true;
    dates = "daily";
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
      };
      extraOptions = {
        startBrowser = false;
        urAccepted = -1;
      };
      folders = {
        "/home/${username}/Documents/Obsidian" = {
          id = "obsidian";
          devices = [ "mobile" ];
        };
      };
    };
    enable = true;
  };

  # thunar stuff
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # polkit
  security.polkit.enable = true;

  # virtualisation.waydroid.enable = true;

  xdg.portal = {
    enable = true;
    # xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # podman for distrobox
  virtualisation.podman.enable = true;

  # using cachix for hyprland
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs.hyprland.enable = true;

  # virtualbox
  virtualisation.virtualbox.host.enable = true;

  # env vars
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
}
