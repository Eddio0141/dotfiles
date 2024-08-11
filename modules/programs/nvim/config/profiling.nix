{
  config = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>ups";
        action = ''
          function()
            vim.cmd([[
              :profile start /tmp/nvim-profile.log
              :profile func *
              :profile file *
            ]])
          end
        '';
        lua = true;
        options.desc = "Profile start";
      }
      {
        mode = "n";
        key = "<leader>upe";
        action = ''
          function()
            vim.cmd([[
              :profile stop
              :e /tmp/nvim-profile.log
            ]])
          end
        '';
        lua = true;
        options.desc = "Profile end";
      }
    ];

    # plugins.which-key = {
    #   registrations = {
    #     "<leader>up" = "Profiling";
    #   };
    # };
  };
}
