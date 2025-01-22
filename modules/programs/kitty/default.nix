{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib;
let
  cfg = config.yuu.programs.kitty;
in
{
  options.yuu.programs.kitty.enable = mkEnableOption "kitty";

  config = (
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        kitty
      ];

      home-manager.users.${username}.programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        font = {
          package = config.stylix.fonts.monospace.package;
          name = config.stylix.fonts.monospace.name;
          size = config.stylix.fonts.sizes.terminal;
        };
        extraConfig = ''
          # Jump around neighboring window Vi key binding
          map ctrl+shift+w>h neighboring_window left
          map ctrl+shift+w>l neighboring_window right
          map ctrl+shift+w>j neighboring_window down
          map ctrl+shift+w>k neighboring_window up

          map ctrl+shift+w>shift+h move_window left
          map ctrl+shift+w>shift+l move_window right
          map ctrl+shift+w>shift+j move_window down
          map ctrl+shift+w>shift+k move_window up

          # Create a new window splitting the space used by the existing one so that
          # the two windows are placed one above the other
          map ctrl+shift+w>s launch --location=hsplit

          # Create a new window splitting the space used by the existing one so that
          # the two windows are placed side by side
          map ctrl+shift+w>v launch --location=vsplit

          # Use nvim as the pager. Remove all ASCII formatting characters.
          scrollback_pager nvim --noplugin -c 'set buftype=nofile' -c 'set noswapfile' -c 'silent! %s/\%x1b\[[0-9;]*[sumJK]//g' -c 'silent! %s/\%x1b]133;[A-Z]\%x1b\\//g' -c 'silent! %s/\%x1b\[[^m]*m//g' -c 'silent! %s///g' -

          map ctrl+t launch --cwd=current --type=tab
        '';
      };
    }
  );
}
