{
  pkgs,
  username,
  ...
}:
let
  hints = (pkgs.callPackage ./package.nix { });
in
{
  services.gnome.at-spi2-core.enable = true;

  users.users.${username}.extraGroups = [ "input" ];

  environment.systemPackages = with pkgs; [
    # From https://github.com/NixOS/nixpkgs/issues/376993#issuecomment-2615199894
    # add `gtk-layer-shell` to `buildInputs`
    hints
    grim
  ];

  home-manager.users.${username} = {
    # https://github.com/AlfredoSequeida/hints/tree/main?tab=readme-ov-file#system-requirements
    home.sessionVariables = {
      ACCESSIBILITY_ENABLED = "1";
      GTK_MODULES = "gail:atk-bridge";
      OOO_FORCE_DESKTOP = "gnome";
      GNOME_ACCESSIBILITY = "1";
      QT_ACCESSIBILITY = "1";
      QT_LINUX_ACCESSIBILITY_ALWAYS_ON = "1";
    };

    systemd.user.services.hintsd = {
      Unit = {
        Description = "Hints daemon";
      };
      Service = {
        Type = "simple";
        ExecStart = "${hints}/bin/hintsd";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
