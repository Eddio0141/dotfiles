{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = ../assets/wallpaper/frieren.png;
    polarity = "dark";
    cursor = {
      package = (
        pkgs.bibata-cursors.overrideAttrs rec {
          version = "2.0.6";
          src = pkgs.fetchFromGitHub {
            owner = "ful1e5";
            repo = "Bibata_Cursor";
            rev = "v${version}";
            hash = "sha256-iLBgQ0reg8HzUQMUcZboMYJxqpKXks5vJVZMHirK48k=";
          };
          bitmaps = pkgs.fetchzip {
            url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v${version}/bitmaps.zip";
            hash = "sha256-8ujkyqby5sPcnscIPkay1gvd/1CH4R9yMJs1nH/mx8M=";
          };
          buildPhase = ''
            runHook preBuild

            ctgen build.toml -p x11 -d $bitmaps/Bibata-Modern-Amber -n 'Bibata-Modern-Amber' -c 'Yellowish and rounded edge bibata cursors.'
            ctgen build.toml -p x11 -d $bitmaps/Bibata-Modern-Classic -n 'Bibata-Modern-Classic' -c 'Black and rounded edge Bibata cursors.'
            ctgen build.toml -p x11 -d $bitmaps/Bibata-Modern-Ice -n 'Bibata-Modern-Ice' -c 'White and rounded edge Bibata cursors.'

            ctgen build.toml -p x11 -d $bitmaps/Bibata-Original-Amber -n 'Bibata-Original-Amber' -c 'Yellowish and sharp edge Bibata cursors.'
            ctgen build.toml -p x11 -d $bitmaps/Bibata-Original-Classic -n 'Bibata-Original-Classic' -c 'Black and sharp edge Bibata cursors.'
            ctgen build.toml -p x11 -d $bitmaps/Bibata-Original-Ice -n 'Bibata-Original-Ice' -c 'White and sharp edge Bibata cursors.'

            runHook postBuild
          '';
        }
      );
      name = "Bibata-Modern-Amber";
      size = 24;
    };
    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "DejaVuSansM Nerd Font";
        package = pkgs.nerd-fonts.dejavu-sans-mono;
      };
    };
  };
}
