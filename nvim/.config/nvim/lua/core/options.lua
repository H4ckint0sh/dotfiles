local opt = vim.opt

-- Session Management
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Line Numbers
opt.relativenumber = true
opt.number = true

-- Enable the tabline
vim.o.showtabline = 2 -- Always show the tab line

-- Use the custom buffer line function
vim.o.tabline = '%!v:lua.MyTabLine()'

-- Tabs & Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
vim.bo.softtabstop = 4

-- Line Wrapping
opt.wrap = false

-- Search Settings
opt.ignorecase = true
opt.smartcase = true

-- Cursor Line
opt.cursorline = true

opt.autoindent = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
vim.diagnostic.config {
  float = { border = "rounded" }, -- add border to diagnostic popups
}

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of keyword
opt.iskeyword:append("-")

-- Disable the mouse while in nvim
opt.mouse = ""

-- Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Utilize Treesitter folds

-- Undo
-- Enable persistent undo globally
vim.opt.undofile = true

-- Ensure the directory for undo files exists
local undo_dir = vim.fn.expand('~/.vim/undo')
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, 'p')
end

-- Set the directory where undo files will be stored
vim.opt.undodir = undo_dir



-- Make the buffer line and other elements transparent
vim.cmd [[
  hi TabLine guibg=NONE ctermbg=NONE
  hi TabLineSel guibg=NONE ctermbg=NONE gui=bold
  hi TabLineFill guibg=NONE ctermbg=NONE
  hi StatusLineMode guibg=NONE cterm=bold
  hi StatusLine guifg=white guibg=NONE cterm=none
  hi StatusLineInfo guifg=white guibg=NONE cterm=none
]]
