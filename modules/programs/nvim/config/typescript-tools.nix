{ pkgs, ... }:
{
  config = {
    extraPackages = with pkgs; [
      typescript
    ];

    plugins.typescript-tools.enable = true;
  };
}
