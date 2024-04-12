{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader><space>" = {
        action = "find_files";
        options.desc = "Finds files in root dir";
      };
      "<leader>/" = {
        action = "live_grep";
        options.desc = "Grep in root dir";
      };
      "<leader>sK" = {
        action = "keymaps";
        options.desc = "Key maps";
      };
      "<leader>ss" = {
        action = "lsp_document_symbols";
        options.desc = "LSP document symbols in current buffer";
      };
      "<leader>sS" = {
        action = "lsp_workspace_symbols";
        options.desc = "LSP workspace symbols";
      };
      "gd" = {
        action = "lsp_definitions";
        options.desc = "Goto definitions";
      };
      "gr" = {
        action = "lsp_references";
        options.desc = "References";
      };
      "gI" = {
        action = "lsp_implementations";
        options.desc = "Goto Implementation";
      };
      "gy" = {
        action = "lsp_type_definitions";
        options.desc = "Goto T[y]pe Definition";
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
