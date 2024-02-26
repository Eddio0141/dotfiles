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
      "<leader>ss" = {
        action = "lsp_document_symbols";
        desc = "LSP document symbols in current buffer";
      };
      "<leader>sS" = {
        action = "lsp_workspace_symbols";
        desc = "LSP workspace symbols";
      };
    };
    extensions = {
      fzf-native.enable = true;
      ui-select = {
        enable = true;
      };
    };
  };
}
