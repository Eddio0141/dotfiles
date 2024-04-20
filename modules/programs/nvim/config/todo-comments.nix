{
  config = {
    keymaps = [
      {
        mode = "n";
        key = "]t";
        action = ''
        require("todo-comments").jump_next()
        '';
        lua = true;
        options.desc = "Jump to next todo";
      }
      {
        mode = "n";
        key = "[t";
        action = ''
        require("todo-comments").jump_prev()
        '';
        lua = true;
        options.desc = "Jump to previous todo";
      }
    ];
    
    plugins.todo-comments = {
      enable = true;
      keymaps = {
        todoTrouble.key = "<leader>st";
        todoTelescope.key = "<leader>sT";
      };
    };
  };
}
