{ pkgs, ... }:
{
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      overseer-nvim
    ];

    extraConfigLua = ''
      require('overseer').setup()
    '';

    # keymaps = [
    #   {
    #     action = "<leader>h";
    #   }
    # ];
  };
}
