actions: with actions; {
  binds = {
    "Mod+Q".action = spawn "kitty";
  };
  spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
  ];
}
