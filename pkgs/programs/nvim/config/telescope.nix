{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader><space>" = {
        action = "find_files";
	desc = "Finds files in root dir";
      };
      "<leader>/" = {
        action = "live_grep";
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
      "gd" = {
        action = "lsp_definitions";
        desc = "Goto definitions";
      };
      "gr" = {
        action = "lsp_references";
        desc = "References";
      };
      "gI" = {
        action = "lsp_implementations";
        desc = "Goto Implementation";
      };
      "gy" = {
        action = "lsp_type_definitions";
        desc = "Goto T[y]pe Definition";
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
