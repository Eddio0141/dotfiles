{
  config = {
    plugins.dap = {
      enable = true;
      extensions = {
        # TODO: fix virtual text
        dap-virtual-text.enable = true;
        dap-ui.enable = true;
      };
    };

    keymaps = [
      {
        key = "<leader>db";
        action = ''function() require'dap'.toggle_breakpoint() end'';
        lua = true;
        options.desc = "Toggle breakpoint";
      }
      {
        key = "<leader>dc";
        action = ''function () require'dap'.continue() end'';
        lua = true;
        options.desc = "Continue";
      }
      {
        key = "<leader>dC";
        action = ''function () require'dap'.run_to_cursor() end'';
        lua = true;
        options.desc = "Run to cursor";
      }
      {
        key = "<leader>di";
        action = ''function () require'dap'.step_into() end'';
        lua = true;
        options.desc = "Step into";
      }
      {
        key = "<leader>do";
        action = ''function () require'dap'.step_over() end'';
        lua = true;
        options.desc = "Step over";
      }
      {
        key = "<leader>dO";
        action = ''function () require'dap'.step_out() end'';
        lua = true;
        options.desc = "Step out";
      }
      {
        key = "<leader>dt";
        action = ''function () require'dap'.terminate() end'';
        lua = true;
        options.desc = "Terminate";
      }
      {
        key = "<leader>dr";
        action = ''function () require'dap'.repl.open() end'';
        lua = true;
        options.desc = "Open REPL";
      }
      {
        key = "<leader>du";
        action = ''function () require'dapui'.toggle() end'';
        lua = true;
        options.desc = "Toggle UI";
      }
    ];
  };
}
