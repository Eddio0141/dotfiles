{ pkgs, ... }:
{
  config.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "my-plugin";
      src = pkgs.fetchFromGitHub {
        owner = "activitywatch";
        repo = "aw-watcher-vim";
        rev = "4ba86d05a940574000c33f280fd7f6eccc284331";
        hash = "sha256-I7YYvQupeQxWr2HEpvba5n91+jYvJrcWZhQg+5rI908=";
      };
    })
  ];
}
