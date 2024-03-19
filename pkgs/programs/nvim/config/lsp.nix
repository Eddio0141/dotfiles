{
  plugins.lsp = {
    enable = true;
    servers = {
      nixd = {
        enable = true;
      };
      jsonls.enable = true;
    };
  };
}
