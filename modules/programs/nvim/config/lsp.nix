{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;
    servers = {
      nil_ls = {
        enable = true;
        settings.formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
      };
      jsonls.enable = true;
      ccls.enable = true;
      omnisharp.enable = true;
    };
  };
}
