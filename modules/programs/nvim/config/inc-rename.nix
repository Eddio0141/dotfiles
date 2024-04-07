{
  config = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>cr";
        action = ''
          function()
            local inc_rename = require("inc_rename")
            return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
          end
        '';
        lua = true;
        options = {
          expr = true;
          desc = "Rename";
        };
      }
    ];

    plugins.inc-rename = {
      enable = true;
    };
  };
}
