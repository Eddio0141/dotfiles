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
    # package = inputs.yazi.packages.x86_64-linux.yazi;
    plugins = {
      ouch = fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "v0.4.0";
        hash = "sha256-eRjdcBJY5RHbbggnMHkcIXUF8Sj2nhD/o7+K3vD3hHY=";
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
      open.prepend_rules = [
        {
          name = "*.zip";
          use = "extract";
        }
      ];
      plugin = {
        prepend_previewers = [
          {
            name = "*.zip";
            run = "archive";
          }
        ];
      };
    };
    keymap = {
      manager.prepend_keymap = [
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
        {
          on = [
            "g"
            "q"
          ];
          run = "cd '~/.local/share/Steam/steamapps/compatdata/2855711661/pfx/drive_c/users/steamuser/AppData/LocalLow/ZeekerssRBLX/Lethal Company/VLogs'";
          desc = "[G]oto high [q]uota v56 logs";
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
