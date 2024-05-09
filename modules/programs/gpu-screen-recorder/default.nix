{ config, lib, pkgs, home-manager, username, ... }:
with lib;
let
  cfg = config.yuu.programs.gpu-screen-recorder;
in
{
  options.yuu.programs.gpu-screen-recorder.enable = mkEnableOption "gpu-screen-recorder";

  config = (mkIf cfg.enable {
    # overlays
    nixpkgs.overlays = [
      (self: super: {
        gpu-screen-recorder = super.gpu-screen-recorder.overrideAttrs (old: {
          postInstall = ''
            install -Dt $out/bin gpu-screen-recorder gsr-kms-server
            mkdir $out/bin/.wrapped
            mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
            makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
            --prefix LD_LIBRARY_PATH : ${self.libglvnd}/lib \
            --suffix PATH : $out/bin
          ''; # prefix -> suffix
        });
        gpu-screen-recorder-gtk = super.gpu-screen-recorder-gtk.overrideAttrs (old: {
          installPhase = ''
            install -Dt $out/bin/ gpu-screen-recorder-gtk
            install -Dt $out/share/applications/ gpu-screen-recorder-gtk.desktop
            gappsWrapperArgs+=(--prefix PATH : /run/wrappers/bin:${super.lib.makeBinPath [ self.gpu-screen-recorder ]})
            # gappsWrapperArgs+=(--prefix PATH : /run/wrappers/bin)
            # we also append /run/opengl-driver/lib as it otherwise fails to find libcuda.
            gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${super.lib.makeLibraryPath [ self.libglvnd ]}:/run/opengl-driver/lib)
            ''; # add /run/wrappers/bin to prefix
        });
      })
    ];
    
    environment.systemPackages = with pkgs; [
      gpu-screen-recorder
      # TODO without gui soon
      gpu-screen-recorder-gtk
    ];

    # to avoid the need to auth
    security.wrappers = {
      gsr-kms-server = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
      };
    };
  });
}
