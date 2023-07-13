{ config, pkgs, ... }:
{
  imports = [ <home-manager/nixos> ];

  home-manager.users.yuu = {
    home.stateVersion = "23.05";

    programs.git = {
      enable = true;
      userName = "Eddio0141";
      userEmail = "eddio0141@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.input-overlay
      ];
    };
  };
}
