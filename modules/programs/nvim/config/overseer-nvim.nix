{ pkgs, ... }:
{
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      overseer-nvim
    ];

    extraConfigLua = ''
      require('overseer').setup()
    '';

    # TODO: keymaps
    # TODO: wait for https://github.com/nix-community/nixvim/issues/1528
    # keymaps = [
    #   {
    #     action = "<leader>h";
    #   }
    # ];
  };
}
