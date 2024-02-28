{ pkgs, ... }:
{
  config = {
    extraPackages = with pkgs; [
      cargo-nextest
      lldb
    ];
    
    extraPlugins = with pkgs.vimPlugins; [
      neotest
    ];

    extraConfigLua = ''
    require("neotest").setup({
      adapters = {
        require("rustaceanvim.neotest")
      },
      status = {
        virtual_text = true
      },
      output = {
        open_on_run = true
      },
    })
    '';

    keymaps = [
      {
        key = "<leader>tt";
        action = ''function() require("neotest").run.run(vim.fn.expand("%")) end'';
        lua = true;
        options.desc = "Run file";
      }
      {
        key = "<leader>tT";
        action = ''function() require("neotest").run.run(vim.loop.cwd()) end'';
        lua = true;
        options.desc = "Run all test files";
      }
      {
        key = "<leader>tr";
        action = ''function() require("neotest").run.run() end'';
        lua = true;
        options.desc = "Run nearest";
      }
      {
        key = "<leader>tl";
        action = ''function() require("neotest").run.run_last() end'';
        lua = true;
        options.desc = "Run last";
      }
      {
        key = "<leader>ts";
        action = ''function() require("neotest").summary.toggle() end'';
        lua = true;
        options.desc = "Toggle summary";
      }
      {
        key = "<leader>to";
        action = ''function() require("neotest").output.open({ enter = true, auto_close = true }) end'';
        lua = true;
        options.desc = "Show output";
      }
      {
        key = "<leader>tO";
        action = ''function() require("neotest").output_panel.toggle() end'';
        lua = true;
        options.desc = "Toggle output panel";
      }
      {
        key = "<leader>tS";
        action = ''function() require("neotest").run.stop() end'';
        lua = true;
        options.desc = "Stop test";
      }
    ];
  };
}
