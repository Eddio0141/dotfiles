{ buildDotnetModule
, fetchFromGitHub
, lib
}:

buildDotnetModule rec {
  pname = "uabea";
  version = "7";

  src = fetchFromGitHub {
    owner = "nesrak1";
    repo = "UABEA";
    rev = "v${version}";
    sha256 = "sha256-fwXf2VV2LMGYY8Rv35E3/LNwoUdTCgBQZtsC4K++ong=";
  };

  patches = [
    ./remove-broken-sources.patch
  ];

  # prePatch = ''
  #   dotnet sln UABEAvalonia.sln remove TexToolWrap/TexToolWrap.vcxproj
  # '';

  projectFile = "UABEAvalonia/UABEAvalonia.csproj";
  nugetDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/nesrak1/UABEA";
    description = "c# uabe for newer versions of unity";
    license = licenses.mit;
  };
}
