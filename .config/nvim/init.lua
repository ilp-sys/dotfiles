require("core.mappings")
require("core.plugins")
require("mason").setup()
require'lspconfig'.clangd.setup{}
require("ibl").setup()
require('Comment').setup()

vim.wo.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
