{ pkgs, lib, config, ... }:
let
  codelldb-config = {
    name = "Launch (CodeLLDB)";
    type = "codelldb";
    request = "launch";
    program.__raw = # lua
      ''
        function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
        end
      '';
    cwd = ''''${workspaceFolder}'';
    stopOnEntry = false;
  };

  coreclr-config = {
    type = "coreclr";
    name = "launch - netcoredbg";
    request = "launch";
    program__raw = # lua
      ''
        function()
          if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
            vim.g.dotnet_build_project()
          end

          return vim.g.dotnet_get_dll_path()
        end'';
    cwd = ''''${workspaceFolder}'';
  };

  gdb-config = {
    name = "Launch (GDB)";
    type = "gdb";
    request = "launch";
    program.__raw = # lua
      ''
        function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
        end'';
    cwd = ''''${workspaceFolder}'';
    stopOnEntry = false;
  };

  lldb-config = {
    name = "Launch (LLDB)";
    type = "lldb";
    request = "launch";
    program.__raw = # lua
      ''
        function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
        end'';
    cwd = ''''${workspaceFolder}'';
    stopOnEntry = false;
  };

  sh-config = lib.mkIf pkgs.stdenv.isLinux {
    type = "bashdb";
    request = "launch";
    name = "Launch (BashDB)";
    showDebugOutput = true;
    pathBashdb = "${lib.getExe pkgs.bashdb}";
    pathBashdbLib = "${pkgs.bashdb}/share/basdhb/lib/";
    trace = true;
    file = ''''${file}'';
    program = ''''${file}'';
    cwd = ''''${workspaceFolder}'';
    pathCat = "cat";
    pathBash = "${lib.getExe pkgs.bash}";
    pathMkfifo = "mkfifo";
    pathPkill = "pkill";
    args = { };
    env = { };
    terminalKind = "integrated";
  };
in
{
  config = {
    plugins = {
      dap = {
        enable = true;
        extensions = {
          dap-virtual-text.enable = true;
          dap-ui.enable = true;
        };
        signs = {
          dapBreakpoint = {
            text = "";
            texthl = "DapBreakpoint";
          };
          dapBreakpointCondition = {
            text = "";
            texthl = "dapBreakpointCondition";
          };
          dapBreakpointRejected = {
            text = "";
            texthl = "DapBreakpointRejected";
          };
          dapLogPoint = {
            text = "";
            texthl = "DapLogPoint";
          };
          dapStopped = {
            text = "";
            texthl = "DapStopped";
          };
        };
        adapters = {
          servers = {
            codelldb =
              let
                port = 13000;
              in
              {
                inherit port;
                host = "127.0.0.1";
                executable = {
                  command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
                  args = [ "--port" "${builtins.toString port}" ];
                };
              };
          };
          executables = {
            bashdb = { command = "${lib.getExe pkgs.bashdb}"; };
            cppdbg = {
              command = "gdb";
              args = [
                "-i"
                "dap"
              ];
            };
            gdb = {
              command = "gdb";
              args = [
                "-i"
                "dap"
              ];
            };
            lldb = {
              command = "${pkgs.lldb}/bin/lldb-vscode";
            };
            coreclr = {
              command = "${lib.getExe pkgs.netcoredbg}";
              args = [ "--interpreter=vscode" ];
            };
          };
        };
        configurations = {
          c = [
            lldb-config
            gdb-config
          ];
          cpp = [
            lldb-config
            gdb-config
            codelldb-config
          ];
          cs = [ coreclr-config ];
          # fsharp = [ coreclr-config ];
          rust = [
            lldb-config
            gdb-config
            codelldb-config
          ];
          sh = [ sh-config ];
        };
      };

      which-key.registrations."<leader>d" = "  Debug";
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
        action = ''
          function()
            require("dap.ext.vscode").load_launchjs(nil, {})
            require("dap").continue()
          end
        '';
        lua = true;
        options.desc = "Continue debugging (or start)";
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

