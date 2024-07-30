{ stdenv
, fetchzip
, lib
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

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt
    cp * -r $out/opt
    ln -s $out/opt/binaryninja $out/bin/binaryninja
  '';

  meta = with lib; {
    homepage = "https://binary.ninja";
    description = "Binary Ninja is an interactive decompiler, disassembler, debugger, and binary analysis platform built by reverse engineers, for reverse engineers.";
    license = licenses.unfree;
  };
}
