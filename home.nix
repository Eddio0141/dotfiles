{ config, pkgs, ... }:
{
  home.username = "yuu";
  home.homeDirectory = "/home/yuu";

    home.stateVersion = "23.05";

    programs.git = {
      enable = true;
      userName = "Eddio0141";
      userEmail = "eddio0141@gmail.com";
    };

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.input-overlay
      ];
    };
}
