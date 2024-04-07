{
  config = {
    plugins.trouble = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>TroubleToggle document_diagnostics<cr>";
        options.desc = "Document Diagnostics (Trouble)";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>TroubleToggle workspace_diagnostics<cr>";
        options.desc = "Document Diagnostics (Trouble)";
      }
    ];
  };
}
