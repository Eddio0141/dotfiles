{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader><space>" = {
        action = "find_files";
	desc = "Finds files in root dir";
      };
      "<leader>/" = {
        action = "grep_string";
	desc = "Grep in root dir";
      };
      "<leader>sK" = {
        action = "keymaps";
        desc = "Key maps";
      };
    };
    extensions = {
      fzf-native.enable = true;
    };
  };
}
