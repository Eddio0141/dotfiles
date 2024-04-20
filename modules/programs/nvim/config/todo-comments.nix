{
  config = {
    keymaps = [
      {
        mode = "n";
        key = "]t";
        action = ''
        function()
          require("todo-comments").jump_next()
        end
        '';
        lua = true;
        options.desc = "Jump to next todo";
      }
      {
        mode = "n";
        key = "[t";
        action = ''
        function() 
          require("todo-comments").jump_prev()
        end
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
