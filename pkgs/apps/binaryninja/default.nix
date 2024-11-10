{
  stdenv,
  fetchzip,
  lib,
  makeWrapper,
  autoPatchelfHook,
  unzip,
  wayland,
  libGL,
  qt6,
  python310,
  glib,
  fontconfig,
  dbus,
  free ? true,
  ...
}:
stdenv.mkDerivation {
  pname = "binaryninja";
  version = if free then "4.1.5747-stable-free" else throw "TODO";
  src =
    if free then
      fetchzip {
        url = "https://cdn.binary.ninja/installers/binaryninja_free_linux.zip";
        hash = "sha256-iTTa5da8rsR1E50HQMqSidAcjT5fq4z6jp3eyg3XEN0=";
      }
    else
      throw "TODO";

  buildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
    wayland
    libGL
    qt6.full
    qt6.qtbase
    python310
    stdenv.cc.cc.lib
    glib
    fontconfig
    dbus
  ];
  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    python310.pkgs.wrapPython
  ];

  dontWrapQtApps = true;
  buildPhase = ":";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt
    cp * -r $out/opt
    makeWrapper $out/opt/binaryninja \
      $out/bin/binaryninja \
      --prefix "QT_QPA_PLATFORM" ":" "wayland"
  '';

  postFixup = ''
    patchelf --debug --add-needed libpython3.so \
      "$out/opt/binaryninja"
  '';

  meta = with lib; {
    homepage = "https://binary.ninja";
    description = "Binary Ninja is an interactive decompiler, disassembler, debugger, and binary analysis platform built by reverse engineers, for reverse engineers.";
    license = licenses.unfree;
  };
}
