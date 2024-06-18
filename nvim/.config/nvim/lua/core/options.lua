local opt          = vim.opt

-- Session Management
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Line Numbers
opt.relativenumber = true
opt.number         = true

-- Enable the tabline
vim.o.showtabline  = 2 -- Always show the tab line

-- Use the custom buffer line function
vim.o.tabline      = '%!v:lua.MyTabLine()'

-- Tabs & Indentation
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.autoindent     = true
vim.o.softtabstop  = 4
-- Use tabs instead of spaces
vim.o.expandtab    = true
-- Make backspace key work as expected
vim.o.backspace    = 'indent,eol,start'


-- Line Wrapping
opt.wrap          = false

-- Search Settings
opt.ignorecase    = true
opt.smartcase     = true

-- Cursor Line
opt.cursorline    = true

opt.autoindent    = true
opt.wildignore    = "*node_modules/**"

-- Appearance
opt.termguicolors = true
opt.background    = "dark"
opt.signcolumn    = "yes"
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
opt.mouse          = ""

-- Folding
opt.foldcolumn     = "0"
opt.foldnestmax    = 0
opt.foldlevel      = 99
opt.foldlevelstart = 99

-- Undo
-- Enable persistent undo globally
vim.opt.undofile   = true

vim.opt.formatoptions:remove('c');
vim.opt.formatoptions:remove('r');
vim.opt.formatoptions:remove('o');
vim.opt.fillchars:append('stl: ');
vim.opt.fillchars:append('eob: ');
vim.opt.fillchars:append('fold: ');
vim.opt.fillchars:append('foldopen: ');
vim.opt.fillchars:append('foldsep: ');
vim.opt.fillchars:append('foldclose:');


-- Make the buffer line and other elements transparent
vim.cmd [[
  hi TabLine guibg=NONE ctermbg=NONE
  hi TabLineSel guibg=NONE ctermbg=NONE gui=bold
  hi TabLineFill guibg=NONE ctermbg=NONE
  hi StatusLineMode guibg=NONE cterm=bold
  hi StatusLine guifg=white guibg=NONE cterm=none
  hi StatusLineInfo guifg=white guibg=NONE cterm=none
]]
