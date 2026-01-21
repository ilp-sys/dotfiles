--------------------------------------------------
-- Bootstrap lazy.nvim
--------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- Basic settings (plugin-independent)
--------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.wo.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

--------------------------------------------------
-- lazy.nvim setup
--------------------------------------------------
require("lazy").setup({

  ------------------------------------------------
  -- Completion
  ------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  ------------------------------------------------
  -- Telescope
  ------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
    end,
  },

  ------------------------------------------------
  -- Git signs
  ------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  ------------------------------------------------
  -- Status line
  ------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end,
  },

  ------------------------------------------------
  -- Copilot
  ------------------------------------------------
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
  },
})

--------------------------------------------------
-- Non-plugin keymaps
--------------------------------------------------
vim.keymap.set("n", "-", vim.cmd.Ex)

--------------------------------------------------
-- nvim-treesitter-setup
--------------------------------------------------
--- Highlighting
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

-- Folds
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

-- Indentation
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"


--------------------------------------------------
-- nvim-lspconfig
--------------------------------------------------

-- (lsp) rust-analyzer
vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['rust-analyzer'] = {},
  },
})
vim.lsp.enable('rust-analyzer')


-- (lsp) clangd
vim.lsp.config('clangd', {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    root_dir = function(fname)
        local util = vim.fs
        local dir = util.find({ "compile_commands.json", ".git" }, { upward = true, path = fname })
        return dir and dir[1] or vim.loop.cwd()
    end,
})
vim.lsp.enable('clangd')

-- (lsp) pyright
vim.lsp.config('pyright', {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
            },
        },
    },
})
vim.lsp.enable('pyright')

-- (lsp) gopls
vim.lsp.config('gopls', {
    settings = {
        gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
        },
    },
    root_dir = function(fname)
        local dir = vim.fs.find({ "go.mod", ".git" }, { upward = true, path = fname })
        return dir and dir[1] or vim.loop.cwd()
    end,
})
vim.lsp.enable('gopls')


