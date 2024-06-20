local options = {
	clipboard = "unnamed,unnamedplus", --- Copy-paste between vim and everything else
	cmdheight = 1, --- Give more space for displaying messages
	completeopt = "menu,menuone,noselect", --- Better autocompletion
	emoji = false, --- Fix emoji display
	expandtab = true, --- Use spaces instead of tabs
	foldcolumn = "0",
	foldnestmax = 0,
	foldlevel = 99, --- Using ufo provider need a large value
	foldlevelstart = 99, --- Expand all folds by default
	ignorecase = true, --- Needed for smartcase
	laststatus = 3, --- Have a global statusline at the bottom instead of one for each window
	mouse = "a", --- Enable mouse
	number = true, --- Shows current line number
	pumheight = 15, --- Max num of items in completion menu
	relativenumber = true, --- Enables relative number
	scrolloff = 8, --- Always keep space when scrolling to bottom/top edge
	shiftwidth = 4, --- Change a number of space characters inserted for indentation
	showtabline = 4, --- Always show tabs
	signcolumn = "yes:2", --- Add extra sign column next to line number
	smartcase = true, --- Uses case in search
	smartindent = true, --- Makes indenting smart
	smarttab = true, --- Makes tabbing smarter will realize you have 4 vs 4
	softtabstop = 4, --- Insert 4 spaces for a tab
	splitright = true, --- Vertical splits will automatically be to the right
	tabstop = 4, --- Insert 4 spaces for a tab
	termguicolors = true, --- Correct terminal colors
	timeoutlen = 300, --- Faster completion (cannot be lower than 200 because then commenting doesn't work)
	updatetime = 300, --- Faster completion
	viminfo = "'1000", --- Increase the size of file history
	wildignore = "*node_modules/**", --- Don't search inside Node.js modules (works for gutentag)
	wrap = false, --- Display long lines as just one line
	writebackup = false, --- Not needed
	autoindent = true, --- Good auto indent
	backspace = "indent,eol,start", --- Making sure backspace works
	swapfile = false,
	conceallevel = 2,
	concealcursor = "", --- Set to an empty string to expand tailwind class when on cursorline
	cursorline = true,
	cursorlineopt = "number",
	encoding = "utf-8", --- The encoding displayed
	errorbells = false, --- Disables sound effect for errors
	fileencoding = "utf-8", --- The encoding written to file
	incsearch = true, --- Start searching before pressing enter
	showmode = false, --- Don't show things like -- INSERT -- anymore
}

local globals = {
	speeddating_no_mappings = 1, --- Disable default mappings for speeddating
}

vim.opt.shortmess:append("c")
vim.opt.formatoptions:remove("c")
vim.opt.formatoptions:remove("r")
vim.opt.formatoptions:remove("o")
vim.opt.fillchars:append("stl: ")
vim.opt.fillchars:append("eob: ")
vim.opt.fillchars:append("fold: ")
vim.opt.fillchars:append("foldopen: ")
vim.opt.fillchars:append("foldsep: ")
vim.opt.fillchars:append("foldclose:")

vim.cmd [[
set statusline=%!v:lua.require('custom.statusline').global()

]]

for k, v in pairs(options) do
	vim.opt[k] = v
end

for k, v in pairs(globals) do
	vim.g[k] = v
end
