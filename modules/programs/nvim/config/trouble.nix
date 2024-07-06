{
  config = {
    plugins.trouble = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics (Trouble)";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Workspace Diagnostics (Trouble)";
      }
    ];
  };
}
