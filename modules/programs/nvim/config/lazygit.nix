{
  config = {
    plugins.lazygit.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<cr>";
        options.desc = "Open LazyGit";
      }
    ];
  };
}
