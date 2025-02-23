{
  username,
  inputs,
  system,
  home-manager,
  config,
  lib,
  pkgs,
  ...
}:
let
  relativePath =
    path:
    assert lib.types.path.check path;
    builtins.elemAt (builtins.match "^/nix/store/[^/]+(.*$)" (toString path)) 0;
  link =
    path:
    let
      relative = relativePath path;
      full = config.programs.nh.flake + relative;
    in
    pkgs.runCommand "link${relative}" { } "ln -s ${full} $out";
in
{
  _module.args = { inherit link; };

  imports = [
    ./de
    ./programs
    ./pack
    ./security
    ./services
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit
            username
            inputs
            system
            link
            ;
        };
        users.${username}.imports = [
          {
            home = {
              username = "${username}";
              homeDirectory = "/home/${username}";
            };
          }
        ];
      };
    }
  ];
}
