{ pkgs, ... }:
{
  extraPlugins = with pkgs; [
    vim-wakatime
  ];
}
