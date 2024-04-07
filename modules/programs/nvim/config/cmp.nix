{
  plugins.cmp = {
    enable = true;
    settings = {
      mapping = {
        "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.confirm({ select = true })";
        "<C-e>" = "cmp.mapping.abort()";
      };
      sources = [
        {
          name = "copilot";
        }
        {
          name = "nvim_lsp";
        }
        {
          # TODO better than path?
          name = "fuzzy_path";
        }
        {
          name = "buffer";
        }
        {
          name = "calc";
        }
      ];
      snippet.expand = ''
      function(args)
        require('luasnip').lsp_expand(args.body)
      end
      '';
    };
  };
}
