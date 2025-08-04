{
  username,
  pkgs,
  inputs,
  link,
  ...
}:
{
  # TODO: many of the stuff can be modules, it comes from casual.nix
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/stylix.nix
    ../../modules/shared.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen5
    inputs.niri.nixosModules.niri
    inputs.stylix.nixosModules.stylix
  ];

  boot.loader.systemd-boot = {
    enable = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  services = {
    # TODO: needed? TODO: not nvidia friendly?
    xserver.videoDrivers = [
      "amdgpu"
      "nvidia"
    ];
  };

  hardware.nvidia.open = false;

  services.printing.enable = true;

  home-manager.users.${username} = {
    home.stateVersion = "25.05";

    imports = [
      ../../modules/stylix-hm.nix
    ];

    # TODO: stuff comes from casual-home.nix
    xdg.configFile = {
      "qt5ct/qt5ct.conf".source = ../../config/qt5ct/qt5ct.conf;
      "qt5ct/colors/Dracula.conf".source =
        pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "qt5";
          rev = "master";
          sha256 = "tfUjAb+edbJ+5qar4IxWr4h3Si6MIwnbCrwI2ZdUFAM=";
        }
        + "/Dracula.conf";
      "tealdeer/config.toml".source = link ../../modules/tealdeer.toml;
    };

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.libsForQt5.breeze-icons;
        name = "breeze-dark";
      };
    };

    programs.home-manager.enable = true;

    programs = {
      ssh = {
        enable = true;
        addKeysToAgent = "yes";
      };
    };

    xdg.dataFile."fonts".source = ../../share/fonts;

    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = [ "yazi-kitty.desktop" ];
        };
      };
      desktopEntries = {
        yazi-kitty = {
          name = "Yazi in Kitty";
          genericName = "File Manager";
          exec = "kitty yazi %f";
          terminal = false;
          categories = [
            "System"
            "FileTools"
            "FileManager"
          ];
          mimeType = [ "inode/directory" ];
        };
      };
    };
  };

  networking.hostName = "yuu-work-laptop";

  services = {
    blueman.enable = true;
  };

  programs = {
    # wifi menu
    nm-applet.enable = true;
    thunderbird.enable = true;
  };

  environment.systemPackages = with pkgs; [
    obsidian
    libreoffice-qt
    nextcloud-client
    keepassxc
    quasselClient
    vial # TODO: combine as "splitkb" module or something with the udev rules and such
    pixi
    toolbox
    ##
    teams-for-linux
    stoken
    ##
  ];

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

  system.stateVersion = "25.05";

  # polkit
  security.polkit.enable = true;

  programs.dconf.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      autoPrune.enable = true;
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  yuu = {
    programs = {
      ghidra.uiScale = 1.5;
      git = {
        enable = true;
        config = {
          user = {
            name = "edcope";
            email = "ed.cope@codethink.co.uk";
          };
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

  services.udev.extraRules = ''
    # vial devices
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
}
