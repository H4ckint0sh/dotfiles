

-- ╭──────────────────────────────────────────────────────────╮
-- │ Setup Colorscheme                                        │
-- ╰──────────────────────────────────────────────────────────╯

-- Set Colorscheme
vim.cmd('colorscheme ' .. H4ckint0sh.colorscheme)
vim.cmd([[set background=dark
  highlight WinSeparator guibg=None]])
-- H4ckint0sh Colors
vim.api.nvim_set_hl(0, 'H4ckint0shPrimary', { fg = "#61afdf" });
vim.api.nvim_set_hl(0, 'H4ckint0shSecondary', { fg = "#e5c07b" });

vim.api.nvim_set_hl(0, 'H4ckint0shPrimaryBold', { bold = true, fg = "#61afdf" });
vim.api.nvim_set_hl(0, 'H4ckint0shSecondaryBold', { bold = true, fg = "#e5c07b" });

vim.api.nvim_set_hl(0, 'H4ckint0shHeader', { bold = true, fg = "#61afdf" });
vim.api.nvim_set_hl(0, 'H4ckint0shHeaderInfo', { bold = true, fg = "#e5c07b" });
vim.api.nvim_set_hl(0, 'H4ckint0shFooter', { bold = true, fg = "#e5c07b" });
-- END
