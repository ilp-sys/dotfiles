-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
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
    { "nvim-lua/plenary.nvim" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim"},

    -- Treesitter for syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- Telescope for fuzzy searching
    { "nvim-telescope/telescope.nvim" },

    -- Git integration
    { "lewis6991/gitsigns.nvim" },

    -- Status line
    { "nvim-lualine/lualine.nvim" },
})

-- Setup LSP
local lspconfig = require("lspconfig")

local function on_attach(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- LSP keymap
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)

    --  Formatting keymap
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, { noremap = true, silent = true, buffer = bufnr, desc = "Format Buffer" })
end

-- clangd setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

lspconfig.clangd.setup({
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
    capabilities = capabilities,
    on_attach = on_attach,
})

-- pyright setup
lspconfig.pyright.setup({
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities,	
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

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "clangd", "pyright" },
	automatic_installation = true,
})

-- Treesitter setup
require("nvim-treesitter.configs").setup({
    ensure_installed = { "cpp", "c", "lua", "python" },
    highlight = { enable = true },
    indent = { enable = true },
})

-- Telescope setup
require("telescope").setup()

-- keymap
vim.g.mapleader = " "

vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, {})

-- General Vim commands
vim.wo.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cursorline = true

vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.cmd.colorscheme("default")
