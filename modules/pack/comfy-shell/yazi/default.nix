{ pkgs, inputs, ... }:
let
  yazi-plugins = inputs.yazi-rs-plugins;
in
{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    # package = inputs.yazi.packages.x86_64-linux.yazi;
    plugins = {
      ouch = inputs.ouch-yazi;
      restore = inputs.restore-yazi;
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
