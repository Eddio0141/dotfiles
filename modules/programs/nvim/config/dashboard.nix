{
  plugins.dashboard = {
    enable = true;
    settings = {
      change_to_vcs_root = true;
      config = {
        footer = [
          "It's like vscode but for weirdos!"
        ];
        # TODO: fix
        # header = [
        #   ""
        #   "                   _             _"
        #   " _   _ _   _ _   _( )___  __   _(_)_ __ ___"
        #   "| | | | | | | | | |// __| \ \ / / | '_ ` _ \\"
        #   "| |_| | |_| | |_| | \__ \  \ V /| | | | | | |"
        #   " \__, |\__,_|\__,_| |___/   \_/ |_|_| |_| |_|"
        #   " |___/"
        #   ""
        # ];
        project.enable = true;
      };
    };
  };
}

