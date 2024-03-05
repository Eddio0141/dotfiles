{
  plugins.nvim-cmp = {
    enable = true;
    sources = [
      { name = "nvim_lsp"; }
      { name = "path"; }
      # TODO fix this
      # { name = "fuzzy_path"; }
      # { name = "buffer"; }
      # { name = "cmdline"; }
      { name = "calc"; }
    ];
    mapping = {
      "<C-n>" = {
        action = "cmp.mapping.select_next_item()";
        modes = ["i"];
      };
      "<C-p>" = {
        action = "cmp.mapping.select_prev_item()";
        modes = ["i"];
      };
      "<C-b>" = "cmp.mapping.scroll_docs(-4)";
      "<C-f>" = "cmp.mapping.scroll_docs(4)";
      "<C-Space>" = "cmp.mapping.confirm({ select = true })";
      "<C-e>" = "cmp.mapping.abort()";
    };
    snippet.expand = "luasnip";
  };
}
