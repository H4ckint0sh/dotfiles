local options = {
	clipboard = "unnamed,unnamedplus", --- Copy-paste between vim and everything else
	cmdheight = 0, --- Give more space for displaying messages
	completeopt = "menu,menuone,noselect", --- Better autocompletion
	emoji = false, --- Fix emoji display
	expandtab = true, --- Use spaces instead of tabs
	ignorecase = true, --- Needed for smart case
	laststatus = 3, --- Have a global status line at the bottom instead of one for each window
	mouse = "a", --- Enable mouse
	number = true, --- Shows current line number
	pumheight = 15, --- Max num of items in completion menu
	relativenumber = true, --- Enables relative number
	scrolloff = 8, --- Always keep space when scrolling to bottom/top edge
	shiftwidth = 4, --- Change a number of space characters inserted for indentation
	showtabline = 4, --- Always show tabs
	spell = true,
	spelllang = "en_us,sv", -- Replace with your language
	signcolumn = "yes:1",
	smartcase = true, --- Uses case in search
	smartindent = true, --- Makes indenting smart
	smarttab = true, --- Makes tabbing smarter will realize you have 4 vs 4
	softtabstop = 4, --- Insert 4 spaces for a tab
	splitright = true, --- Vertical splits will automatically be to the right
	tabstop = 4, --- Insert 4 spaces for a tab
	termguicolors = true, --- Correct terminal colors
	viminfo = "'1000", --- Increase the size of file history
	wildignore = "*node_modules/**", --- Don't search inside Node.js modules (works for gutentag)
	wrap = false, --- Display long lines as just one line
	writebackup = false, --- Not needed
	autoindent = true, --- Good auto indent
	backspace = "indent,eol,start", --- Making sure backspace works
	swapfile = false,
	undofile = true,
	timeoutlen = 300, --- Faster completion (cannot be lower than 200 because then commenting doesn't work)
	updatetime = 100, --- Faster completion
	conceallevel = 2,
	concealcursor = "", --- Set to an empty string to expand tailwind class when on cursorline
	cursorline = true,
	cursorlineopt = "number,line",
	encoding = "utf-8", --- The encoding displayed
	errorbells = false, --- Disables sound effect for errors
	fileencoding = "utf-8", --- The encoding written to file
	incsearch = true, --- Start searching before pressing enter
	showmode = false, --- Don't show things like -- INSERT -- anymore
}

vim.opt.shortmess:append("c")
vim.opt.formatoptions:remove("c")
vim.opt.formatoptions:remove("r")
vim.opt.formatoptions:remove("o")
vim.opt.fillchars:append("stl: ")

for k, v in pairs(options) do
	vim.opt[k] = v
end
