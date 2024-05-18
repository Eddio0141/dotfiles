{ username, inputs, system, home-manager, ... }:
{
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
        extraSpecialArgs = { inherit username inputs system; };
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
