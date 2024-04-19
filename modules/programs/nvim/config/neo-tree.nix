{
  config = {
    plugins.neo-tree = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Explore NeoTree";
      }
      {
        mode = "n";
        key = "<leader>r";
        action = "<cmd>Neotree reveal<cr>";
        options.desc = "Reveal current file in NeoTree";
      }
    ];
  };
}
