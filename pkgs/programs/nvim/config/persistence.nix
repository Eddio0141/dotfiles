{
  config = {
    plugins.persistence = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>qs";
        action = ''
          function() require("persistence").load() end
        '';
        lua = true;
        options.desc = "Restore session";
      }
    ];
  };
}
