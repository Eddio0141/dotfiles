{
  plugins.lsp = {
    enable = true;
    servers = {
      nixd = {
        enable = true;
        settings = {
          # nixpkgs = nixpkgs;
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
      lua-ls.enable = true;
    };
  };
}
