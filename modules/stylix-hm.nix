{ lib, ... }:
{
  stylix.targets = {
    yazi.enable = false;
    hyprpaper.enable = lib.mkForce false;
    kitty.enable = false;
    waybar.enable = false;
  };
}
