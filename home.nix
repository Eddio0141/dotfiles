{ config, pkgs, username, inputs, system, ... }:
{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 16;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "Breeze-Dark";
    };
    iconTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze-dark";
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
  };

  programs.home-manager.enable = true;

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "daily";
  };

  programs.git = {
    enable = true;
    userName = "Eddio0141";
    userEmail = "eddio0141@gmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      advice.addIgnoredFile = "false";
      pull.rebase = "false";
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.input-overlay
    ];
  };

  xdg.configFile."neofetch/ascii-anime".source = ./config/neofetch/ascii-anime;

  # zsh
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake '.#desktop'";
      update-test = "sudo nixos-rebuild test --flake '.#desktop'";
      upgrade = "nix flake update";
      neofetch = "neofetch --source ~/.config/neofetch/ascii-anime";
    };

    # oh my zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "fino-time";
    };

    initExtra = ''
if [[ $- = *i* ]]; then
  neofetch --source ~/.config/neofetch/ascii-anime

  echo "Welcome back $USER!"
fi
'';
  };

  programs.wofi = {
    enable = true;
    style = builtins.readFile ./config/wofi/style.css;
  };

  # mangohud
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      position = "top-right";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."qt5ct/qt5ct.conf".source = ./config/qt5ct/qt5ct.conf;

  xdg.configFile."qt5ct/colors/Dracula.conf".source = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "qt5";
    rev = "master";
    sha256 = "tfUjAb+edbJ+5qar4IxWr4h3Si6MIwnbCrwI2ZdUFAM=";
  } + "/Dracula.conf";

  xdg.dataFile."fonts".source = ./share/fonts;

  # hyprpaper
  xdg.configFile."hypr/hyprpaper.conf".source = ./config/hypr/hyprpaper.conf;

  # TODO add dolphin settings

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      stylua
      ripgrep
      lazygit
      nodejs
      fd
      cargo-nextest
      fish
      shfmt
      typescript
      nodePackages.typescript-language-server
      taplo
      marksman
    ];
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraLuaConfig =
      let
        lib = pkgs.lib;
        plugins = with pkgs.vimPlugins; [
          # LazyVim
          LazyVim
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          conform-nvim
          dashboard-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          indent-blankline-nvim
          lualine-nvim
          neo-tree-nvim
          neoconf-nvim
          neodev-nvim
          noice-nvim
          nui-nvim
          nvim-cmp
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-spectre
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          tokyonight-nvim
          trouble-nvim
          vim-illuminate
          vim-startuptime
          which-key-nvim
          guess-indent-nvim
          copilot-cmp
          copilot-lua
          neotest
          neotest-rust
          FixCursorHold-nvim
          vim-wakatime
          presence-nvim
          { name = "LuaSnip"; path = luasnip; }
          { name = "catppuccin"; path = catppuccin-nvim; }
          { name = "mini.ai"; path = mini-nvim; }
          { name = "mini.bufremove"; path = mini-nvim; }
          { name = "mini.comment"; path = mini-nvim; }
          { name = "mini.indentscope"; path = mini-nvim; }
          { name = "mini.pairs"; path = mini-nvim; }
          { name = "mini.surround"; path = mini-nvim; }
        ];
        mkEntryFromDrv = drv:
          if lib.isDerivation drv then
            { name = "${lib.getName drv}"; path = drv; }
          else
            drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
        ''
          require("lazy").setup({
            defaults = {
              lazy = true,
            },
            dev = {
              -- reuse files from pkgs.vimPlugins.*
              path = "${lazyPath}",
              patterns = { "." },
              -- fallback to download
              fallback = true,
            },
            spec = {
              { "LazyVim/LazyVim", import = "lazyvim.plugins" },
              -- The following configs are needed for fixing lazyvim on nix
              -- force enable telescope-fzf-native.nvim
              { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
              -- disable mason.nvim, use programs.neovim.extraPackages
              { "williamboman/mason-lspconfig.nvim", enabled = false },
              { "williamboman/mason.nvim", enabled = false },
              -- import/override with your plugins
              { import = "plugins" },
              -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
              { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
            },
          })
        '';
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
          c
          lua
          vimdoc
          bash
          rust
          regex
          markdown_inline
        ])).dependencies;
      };
    in
      "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./config/lazyvim/lua;

  wayland.windowManager.sway = {
    # enable = true;
    package = null;
    # systemd.enable = true;
    extraSessionCommands = ''
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME=qt5ct
    '';
    # swaynag.enable = true;
    config =
      let
        mod = "Mod4";
        term = "${pkgs.kitty}/bin/kitty";
      in {
        startup = [
          { command = "waybar"; always = true; }
          { command = "dunst"; always = true; }
          { command = "hyprpaper"; always = true; }
          { command = "firefox"; always = true; }
          { command = "clementine"; always = true; }
          { command = "dolphin --daemon"; always = true; }
          { command = "thunderbird"; always = true; }
          { command = "obsidian"; always = true; }
          { command = "steam -silent"; always = true; }
          { command = "vesktop"; always = true; }
          { command = "wl-paste --type text --watch cliphist store"; always = true; }
          { command = "wl-paste --type image --watch cliphist store"; always = true; }
          { command = "fcitx5 -d"; always = true; }
          { command = "thunar --daemon"; always = true; }
          { command = "${pkgs.autotiling-rs}"; always = true; }
        ];
        modifier = "${mod}";
        terminal = "${term}";
        keycodebindings = pkgs.lib.mkOptionDefault {
          "XF86AudioRaiseVolume" = "exec pamixer -i 5";
          "XF86AudioLowerVolume" = "exec pamixer -d 5";
        };
        keybindings = pkgs.lib.mkOptionDefault {
          "${mod}+q" = "exec ${term}";
          "${mod}+w" = "kill";
          "${mod}+e" = "dolphin";
          "${mod}+t" = "floating toggle";
          "${mod}+s" = "wofi --show drun -I -m -i -W 25% -H 75%";
          # bind = $mainMod, P, pseudo, # dwindle
          # bind = $mainMod, J, togglesplit, # dwindle
          # bind = $mainMod, F, fullscreen,
          # bind = $mainMod, G, togglegroup,
          # bind = $mainMod, H, lockactivegroup, toggle
          # bind = $mainMod, Next, changegroupactive, f
          # bind = $mainMod, Prior, changegroupactive, b
          # bind = $mainMod SHIFT, End, moveoutofgroup,
          # bind = $mainMod SHIFT, E, workspace, empty

          # bind = $mainMod, mouse_up, workspace, e+1
          # bind = $mainMod, mouse_down, workspace, e-1

          # bindm = $mainMod, mouse:272, movewindow
          # bindm = $mainMod, mouse:273, resizewindow

          # bind = $mainMod, comma, focusmonitor, 0
          # bind = $mainMod, period, focusmonitor, 1

          "ctrl+print" = "grimblast --notify --freeze copysave area";

          "${mod}+alt+p" = "clementine --play-pause";
          "${mod}+alt+o" = "clementine --next";
          "${mod}+alt+i" = "clementine --previous";
        };
      };
  };
}

