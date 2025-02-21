{
  home-manager,
  dotfilesPath,
}:
let
  removeFirstCh = str: (builtins.substring 1 ((builtins.stringLength str) - 1) str);
  linkImpure =
    pkgs: path:
    let
      pathStr = toString path;
      name = home-manager.lib.hm.strings.storeFileName (baseNameOf pathStr);
    in
    (pkgs.runCommandLocal name { } ''ln -s ${pkgs.lib.escapeShellArg pathStr} $out'');
in
{
  linkPaths = {
    de = {
      niri = pkgs: path: (linkImpure pkgs ("${dotfilesPath}/de/niri" + (removeFirstCh path)));
    };
    base = pkgs: path: (linkImpure pkgs ("${dotfilesPath}" + (removeFirstCh path)));
  };
}
