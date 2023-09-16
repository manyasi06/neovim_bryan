
require("mason").setup()

require('plugins')
require('color_scheme')
require('lsp_config')
require('custom_toggle')

vim.cmd([[set expandtab shiftwidth=2 tabstop=2 softtabstop=2]])
vim.cmd([[set mouse=a]])
vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
vim.cmd[[colorscheme tokyonight]]

