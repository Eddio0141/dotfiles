{ pkgs, helpers, ... }:
{
  imports = [
    ./neo-tree.nix
    ./toggleterm.nix
    ./which-key.nix
    ./telescope.nix
    ./airline.nix
    ./lsp.nix
    ./bufferline.nix
    ./persistence.nix
    ./alpha.nix
    ./treesitter.nix
    ./autoclose.nix
    ./mini.nix
    ./better-escape.nix
    ./cmp-buffer.nix
    ./cmp-calc.nix
    ./cmp-cmdline.nix
    ./cmp-fuzzy-path.nix
    ./cmp-path.nix
    ./comment-nvim.nix
    ./conform-nvim.nix
    ./coverage.nix
    ./crates-nvim.nix
    ./dap.nix
    ./fidget.nix
    ./flash.nix
    ./friendly-snippets.nix
    ./hardtime.nix
    ./hmts.nix
    ./indent-blankline.nix
    ./leap.nix
    ./lint.nix
    ./nix.nix
    ./rustaceanvim.nix
    ./surround.nix
    ./trouble.nix
    ./yanky.nix
    ./noice.nix
    ./presence-nvim.nix
  ];

  config = {
    colorschemes.tokyonight.enable = true;

    enableMan = true;

    extraPackages = with pkgs; [
      ripgrep
      lazygit
    ];

    extraPlugins = with pkgs.vimPlugins; [
      lazygit-nvim
    ];

    globals = {
      mapleader = " ";
    };
    options = {
      number = true;
      wrap = true;
      clipboard = "unnamedplus";
    };

    viAlias = true;
    vimAlias = true;

    autoGroups = {
      close_with_q = {};
    };

    autoCmd = [
      {
        event = "FileType";
        group = "close_with_q";
        pattern = [
          "PlenaryTestPopup"
          "help"
          "lspinfo"
          "man"
          "notify"
          "qf"
          "query"
          "spectre_panel"
          "startuptime"
          "tsplayground"
          "neotest-output"
          "checkhealth"
          "neotest-summary"
          "neotest-output-panel"
        ];
        callback = helpers.mkRaw ''
        function(arg)
          vim.bo[arg.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = arg.buf, silent = true})
        end
        '';
      }
    ];

    keymaps = [
      {
        mode = ["i" "x" "n" "s"];
        key = "<C-s>";
        action = "<cmd>write<cr><ESC>";
        options.desc = "Save";
      }
      {
        mode = ["n" "t"];
        key = "<C-h>";
        action = "<cmd>wincmd h<cr>";
        options.desc = "Move cursor to window left";
      }
      {
        mode = ["n" "t"];
        key = "<C-j>";
        action = "<cmd>wincmd j<cr>";
        options.desc = "Move cursor to window down";
      }
      {
        mode = ["n" "t"];
        key = "<C-k>";
        action = "<cmd>wincmd k<cr>";
        options.desc = "Move cursor to window up";
      }
      {
        mode = ["n" "t"];
        key = "<C-l>";
        action = "<cmd>wincmd l<cr>";
        options.desc = "Move cursor to window right";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
	key = "<leader>gg";
	action = "<cmd>LazyGit<cr>";
        options.desc = "Open LazyGit";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ''
          function()
            local bd = require("mini.bufremove").delete
            if vim.bo.modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
              if choice == 1 then -- Yes
                vim.cmd.write()
                bd(0)
              elseif choice == 2 then -- No
                bd(0, true)
              end
            else
              bd(0)
            end
          end
        '';
        lua = true;
        options.desc = "Delete buffer";
      }
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>qa<cr>";
        options.desc = "Quit all";
      }
      {
        mode = "n";
        key = "K";
        action = "vim.lsp.buf.hover";
        lua = true;
        options.desc = "Hover";
      }
      {
        mode = "n";
        key = "gK";
        action = "vim.lsp.buf.signature_help";
        lua = true;
        options.desc = "Signature help";
      }
      {
        mode = "i";
        key = "<c-k>";
        action = "vim.lsp.buf.signature_help";
        lua = true;
        options.desc = "Signature help";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>Telescope lsp_references<cr>";
        options.desc = "References";
      }
      {
        mode = ["n" "v"];
        key = "<leader>ca";
        action = "vim.lsp.buf.code_action";
        lua = true;
        options.desc = "Code action";
      }
      {
        mode = ["i" "n"];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options.desc = "Escape and clear hlsearch";
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>m .+1<cr>==";
        options.desc = "Move down";
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>m .-2<cr>==";
        options.desc = "Move up";
      }
    ];
  };
}
