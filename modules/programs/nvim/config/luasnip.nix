{
  config = {
    plugins.luasnip.enable = true;

    keymaps = [
      {
        key = "<tab>";
        mode = "i";
        action = ''
          function () 
            return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
          end
        '';
        lua = true;
        options = {
          desc = "Jump or expand snippet";
          expr = true;
          silent = true;
        };
      }
      {
        key = "<tab>";
        mode = "s";
        action = ''function() require("luasnip").jump(1) end'';
        lua = true;
        options.desc = "Jump snippet forwards";
      }
      {
        key = "<s-tab>";
        mode = [ "i" "s" ];
        action = ''function () require("luasnip").jump(-1) end'';
        lua = true;
        options.desc = "Jump snippet backwards";
      }
    ];
  };
}
