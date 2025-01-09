-- Lazy.nvim setup
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")
require("lazy").setup({
     -- LSP configuration
    { "neovim/nvim-lspconfig" },

    -- Auto-completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },

    -- Formatter and diagnostics
    { "jose-elias-alvarez/null-ls.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim"},
    { "neovim/nvim-lspconfig"},

    -- Treesitter for syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- File explorer
    { "nvim-tree/nvim-tree.lua" },

    -- Telescope for fuzzy searching
    { "nvim-telescope/telescope.nvim" },

    -- Git integration
    { "lewis6991/gitsigns.nvim" },

    -- Status line
    { "nvim-lualine/lualine.nvim" },
})

-- Setup LSP (clangd for C++)
local lspconfig = require("lspconfig")

lspconfig.clangd.setup({
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = function(_, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    end,
})

-- Auto-completion setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
})

-- Treesitter setup
require("nvim-treesitter.configs").setup({
    ensure_installed = { "cpp", "c", "lua" },
    highlight = { enable = true },
	autopair = { },
    indent = { enable = true },
})

-- Telescope setup
require("telescope").setup()

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup()


-- Null-ls setup
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- Formatters
        null_ls.builtins.formatting.clang_format,  -- C/C++
        null_ls.builtins.formatting.prettier,     -- JavaScript, TypeScript, etc.

    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_buf_set_keymap(
                bufnr,
                "n",
                "<leader>f",
                "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
                { noremap = true, silent = true, desc = "Format Buffer" }
            )
        end
    end,
})

-- keymap
vim.g.mapleader = " "

vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, {})
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format Buffer" })

-- General Vim commands
vim.wo.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.cmd('set clipboard=unnamed')

