{
  plugins.noice = {
    enable = true;
    # TODO don't override the whole table, but extend to it
    cmdline.format = {
      cmdline = {pattern = "^:"; icon = ""; lang = "vim";};
      search_down = {kind = "search"; pattern = "^/"; icon = " "; lang = "regex";};
      search_up = {kind = "search"; pattern = "?%?"; icon = " "; lang = "regex";};
      filter = {pattern = "^:%s*!"; icon = "$"; lang = "bash";};
      lua = {pattern = "^:%s*lua%s+"; icon = ""; lang = "lua";};
      help = {pattern = "^:%s*he?l?p?%s+"; icon = "";};
      inc_rename = { pattern = "^:IncRename%s+"; icon = "󰑕"; };
      input = {};
    };
  };
}
