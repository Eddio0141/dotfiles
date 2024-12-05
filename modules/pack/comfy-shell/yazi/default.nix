{ pkgs, ... }:
let
  fetchFromGitHub = pkgs.fetchFromGitHub;

  yazi-plugins = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    hash = "sha256-By8XuqVJvS841u+8Dfm6R8GqRAs0mO2WapK6r2g7WI8=";
  };
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = {
      ouch = fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "main";
        hash = "sha256-fEfsHEddL7bg4z85UDppspVGlfUJIa7g11BwjHbufrE=";
      };
      restore = fetchFromGitHub {
        owner = "boydaihungst";
        repo = "restore.yazi";
        rev = "master";
        hash = "sha256-yjjmy96tg10s+PSzPlL/BdyUUXwI0u+U00COrLwX8WI=";
      };
      git = "${yazi-plugins}/git.yazi";
    };
    settings = {
      opener = {
        extract = [
          {
            run = "ouch d -y \"$@\"";
            desc = "Extract here with ouch";
            for = "unix";
          }
        ];
      };
      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };
    keymap = {
      manager.append_keymap = [
        {
          on = [
            "c"
            "a"
          ];
          run = "plugin ouch --args=zip";
          desc = "Archive selected files";
        }
        {
          on = "u";
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }
      ];
    };
    initLua = ./init.lua;
  };

  xdg.configFile = {
    # yazi extra stuff
    "yazi/theme.toml".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/yazi/refs/heads/main/themes/macchiato/catppuccin-macchiato-pink.toml";
      hash = "sha256-+h8+QfUoYq7Un07GFnpg5f2ZeQORdhDpAgwX0iNDfnI=";
    };
  };
}
