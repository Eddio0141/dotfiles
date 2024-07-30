{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;
    servers = {
      nil_ls = {
        enable = true;
        settings = {
          formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
          nix.flake.autoArchive = true;
        };
      };
      jsonls.enable = true;
      clangd.enable = true;
      omnisharp = {
        enable = true;
        settings = {
          enableImportCompletion = true;
          enableRoslynAnalyzers = true;
          organizeImportsOnFormat = true;
          enableMsBuildLoadProjectsOnDemand = true;
        };
      };
    };
  };
}
