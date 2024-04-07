{
  config = {
    globals = {
      rustaceanvim.tools.test_executor = "background";
    };

    plugins.rustaceanvim = {
      enable = true;
      rustAnalyzerPackage = null;
    };
  };
}
