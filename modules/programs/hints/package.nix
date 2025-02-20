{
  lib,
  python3,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  at-spi2-core,
  libwnck,
  gtk-layer-shell,
}:
python3.pkgs.buildPythonApplication {
  pname = "hints";
  version = "unstable-2025-02-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AlfredoSequeida";
    repo = "hints";
    rev = "4bf8d80e4d499220b4a63d0abf7d4d1e93a160ee";
    hash = "sha256-G8XFq43Wp+VjMiHWGY0Bw5ukHpN/c2lygwqXDmdJ6CM=";
  };

  disabled = python3.pkgs.pythonOlder "3.10";

  patches = [ ./hints.patch ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    pygobject3
    pillow
    pyscreenshot
    opencv-python
    pyatspi
    evdev
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk-layer-shell
    at-spi2-core
    libwnck # for X11
  ];

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Navigate GUIs without a mouse by typing hints in combination with modifier keys";
    homepage = "https://github.com/AlfredoSequeida/hints";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
