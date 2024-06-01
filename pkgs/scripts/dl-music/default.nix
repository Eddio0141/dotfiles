{ writeShellApplication, yt-dlp }:
writeShellApplication {
  name = "dl-music";

  runtimeInputs = [ yt-dlp ];

  text = ''
    yt-dlp -x --embed-thumbnail --no-playlist -o "%(title)s" "$@"
  '';
}
