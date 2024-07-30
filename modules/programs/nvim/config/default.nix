{ pkgs, helpers, ... }:
{
  imports = [
    ./dashboard.nix
    ./neo-tree.nix
    ./toggleterm.nix
    ./which-key.nix
    ./telescope.nix
    ./lsp.nix
    ./bufferline.nix
    ./persistence.nix
    ./alpha.nix
    ./treesitter.nix
    ./mini.nix
    ./comment.nix
    ./conform-nvim.nix
    ./coverage.nix
    ./crates-nvim.nix
    ./dap.nix
    ./fidget.nix
    ./friendly-snippets.nix
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
    ./cmp.nix
    ./nvim-neotest.nix
    ./profiling.nix
    ./notify.nix
    ./luasnip
    ./inc-rename.nix
    ./neogen.nix
    ./spectre.nix
    ./aw-watcher-vim.nix
    ./lualine.nix
    ./typescript-tools.nix
    ./ts-autotag.nix
    ./todo-comments.nix
    ./nvim-autopairs.nix
    ./overseer-nvim.nix
    ./lazygit.nix
  ];

  config = {
    colorschemes.tokyonight.enable = true;

    enableMan = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
    ];

    globals = {
      mapleader = " ";
    };

    globalOpts = {
      smartcase = true;
      ignorecase = true;
    };

    opts = {
      number = true;
      relativenumber = true;
      wrap = true;
      clipboard = "unnamedplus";
      confirm = true;
      cursorline = true;
      expandtab = true;
      foldmethod = "manual";
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
    };

    viAlias = true;
    vimAlias = true;

    autoGroups = {
      close_with_q = { };
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
      {
        event = [ "BufRead" "BufNewFile" ];
        command = "setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2";
        desc = "Tab to spaces, 2 spaces";
        pattern = [ "*.js" "*.cpp" "*.h" ];
      }
    ];

    keymaps = [
      # command line movement
      {
        mode = "c";
        key = "<c-h>";
        action = "<left>";
        options.desc = "Cmdline left";
      }
      {
        mode = "c";
        key = "<c-l>";
        action = "<right>";
        options.desc = "Cmdline right";
      }
      {
        mode = "c";
        key = "<c-k>";
        action = "<up>";
        options.desc = "Cmdline up";
      }
      {
        mode = "c";
        key = "<c-j>";
        action = "<down>";
        options.desc = "Cmdline down";
      }

      {
        mode = [ "i" "x" "n" "s" ];
        key = "<C-s>";
        action = "<cmd>write<cr><ESC>";
        options.desc = "Save";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-h>";
        action = "<cmd>wincmd h<cr>";
        options.desc = "Move cursor to window left";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-j>";
        action = "<cmd>wincmd j<cr>";
        options.desc = "Move cursor to window down";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-k>";
        action = "<cmd>wincmd k<cr>";
        options.desc = "Move cursor to window up";
      }
      {
        mode = [ "n" "t" ];
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
        key = "<leader>bo";
        action = "<cmd>BufferLineCloseOthers<cr>";
        options.desc = "Delete other buffers";
      }
      {
        mode = "n";
        key = "<leader>br";
        action = "<cmd>BufferLineCloseRight<cr>";
        options.desc = "Delete buffers to the right";
      }
      {
        mode = "n";
        key = "<leader>bl";
        action = "<cmd>BufferLineCloseLeft<cr>";
        options.desc = "Delete buffers to the left";
      }
      {
        mode = "n";
        key = "<leader>fn";
        action = "<cmd>enew<cr>";
        options.desc = "New file";
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
        mode = [ "n" "v" ];
        key = "<leader>ca";
        action = "vim.lsp.buf.code_action";
        lua = true;
        options.desc = "Code action";
      }
      {
        mode = [ "i" "n" ];
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
      {
        mode = "i";
        key = "<A-j>";
        action = "<esc><cmd>m .+1<cr>==gi";
        options.desc = "Move down";
      }
      {
        mode = "i";
        key = "<A-k>";
        action = "<esc><cmd>m .-2<cr>==gi";
        options.desc = "Move up";
      }
      {
        mode = "v";
        key = "<A-j>";
        action = ":m '>+1<cr>gv=gv";
        options.desc = "Move down";
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m '<-2<cr>gv=gv";
        options.desc = "Move up";
      }
      {
        mode = "n";
        key = "<leader>w-";
        action = "<C-W>s";
        options.desc = "Split window below";
      }
      {
        mode = "n";
        key = "<leader>w|";
        action = "<C-W>v";
        options.desc = "Split window right";
      }
      {
        mode = "n";
        key = "<leader>wd";
        action = "<C-W>c";
        options.desc = "Delete window";
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Increase window width";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Increase window width";
      }
      {
        mode = "n";
        key = "<leader>cl";
        action = "<cmd>LspInfo<cr>";
        options.desc = "lsp info";
      }
      {
        mode = "n";
        key = "gD";
        action = "vim.lsp.buf.declaration";
        options.desc = "Goto declaration";
      }
      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }
    ];
  };
}
