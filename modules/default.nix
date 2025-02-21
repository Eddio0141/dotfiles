{
  username,
  inputs,
  system,
  home-manager,
  config,
  ...
}:
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
        extraSpecialArgs = {
          inherit
            username
            inputs
            system
            ;
          nixConfig = config;
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
