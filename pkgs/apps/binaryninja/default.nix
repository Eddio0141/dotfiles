{ stdenv
, fetchzip
, lib
, makeWrapper
, free ? true
, ...
}:
stdenv.mkDerivation {
  pname = "binaryninja";
  version = if free then "4.1.5747-stable-free" else throw "TODO";
  src =
    if free then
      fetchzip
        {
          url = "https://cdn.binary.ninja/installers/binaryninja_free_linux.zip";
          hash = "sha256-ItzkG2t+wTRpHd2wXxZekyBJqS12D9MAzY6/U38tEfI=";
        }
    else
      throw "TODO";

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt
    cp * -r $out/opt
    makeWrapper $out/opt/binaryninja \
      $out/bin/binaryninja \
      --prefix "QT_QPA_PLATFORM" ":" "wayland"
  '';

  meta = with lib; {
    homepage = "https://binary.ninja";
    description = "Binary Ninja is an interactive decompiler, disassembler, debugger, and binary analysis platform built by reverse engineers, for reverse engineers.";
    license = licenses.unfree;
  };
}
