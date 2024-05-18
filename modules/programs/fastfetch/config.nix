{
  "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
  logo = ./ascii-anime;
  modules = [
    "title"
    "separator"
    "os"
    "host"
    "kernel"
    "uptime"
    "packages"
    "shell"
    "display"
    "de"
    "wm"
    "wmtheme"
    "theme"
    "icons"
    "font"
    "cursor"
    "terminal"
    "terminalfont"
    "cpu"
    # TODO: override option for modules since like laptop can't really load gpu info fast enough
    # "gpu"
    "memory"
    "swap"
    "disk"
    "localip"
    "battery"
    "poweradapter"
    "locale"
    "break"
    "colors"
  ];
}
