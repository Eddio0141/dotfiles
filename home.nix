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

  # TODO waybar is only when hyprland is enabled
  programs.waybar = {
    enable = true;
    # TODO wait for this fix
    # package = inputs.waybar.packages.${system}.waybar;
    package = pkgs.waybar;
    style = ./config/waybar/style.css;
    settings = import ./config/waybar/config;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
    systemd.enable = true;
    xwayland.enable = true;
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

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vadimcn.vscode-lldb
      serayuzgur.crates
      mkhl.direnv
      ms-azuretools.vscode-docker
      usernamehw.errorlens
      github.copilot
      github.copilot-chat
      wmaurer.change-case
      ms-ceintl.vscode-language-pack-ja
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-slideshow
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      ms-python.vscode-pylance
      ms-python.python
      mechatroner.rainbow-csv
      rust-lang.rust-analyzer
      foxundermoon.shell-format
      wakatime.vscode-wakatime
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      { name = "discord-vscode"; publisher = "icrawl"; version = "5.8.0"; sha256 = "IU/looiu6tluAp8u6MeSNCd7B8SSMZ6CEZ64mMsTNmU="; }
      { name = "feather-vscode"; publisher = "melishev"; version = "1.0.1"; sha256 = "sFgNgNAFlTfx6m+Rp5lQxWnjSe7LLzB6N/gq7jQhRJs="; }
      { name = "cosmicsarthak-neon-theme"; publisher = "cosmicsarthak"; version = "4.4.7"; sha256 = "/vuogor5TMuBY8z9tJsd0PZAoPixgCYJsEfxHA14I/Q="; }
      { name = "theme-pink-cat-boo"; publisher = "ftsamoyed"; version = "1.3.0"; sha256 = "FD7fim0sRWAADzDAbhV3dnYW3mxoSgVPLs5Wkg5r01k="; }
      { name = "vscode-rhai"; publisher = "rhaiscript"; version = "0.6.6"; sha256 = "Yw+wq67u55Hr0Kan/3RrG8Rf6F2pU2FvkD30i4S3paE="; }
      { name = "vscode-todo-highlight"; publisher = "wayou"; version = "1.0.5"; sha256 = "CQVtMdt/fZcNIbH/KybJixnLqCsz5iF1U0k+GfL65Ok="; }
      { name = "toml"; publisher = "be5invis"; version = "0.6.0"; sha256 = "yk7buEyQIw6aiUizAm+sgalWxUibIuP9crhyBaOjC2E="; }
      { name = "vscode-counter"; publisher = "uctakeoff"; version = "3.4.0"; sha256 = "4kdcq+a366PA1Lh2kwx37qV6YxWvqzmUVByRxpvul9g="; }
    ];
  };

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
    ];
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      direnv-vim
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
        ])).dependencies;
      };
    in
      "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./config/lazyvim/lua;
}
