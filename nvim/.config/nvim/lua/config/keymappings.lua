local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }
local silent = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Normal --
keymap("n", "<leader>a", ":Alpha<cr>", opts)
keymap(
	"n",
	"<leader>b",
	":lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
	opts
)
keymap("n", "<leader>x", "::lua require('mini.bufremove').delete(0, false)<CR>", opts)
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<leader>e", "<cmd>lua require('nvim-tree.api').tree.toggle()<CR>", opts)
keymap("n", "<leader>w", ":w!<CR>", opts)
keymap("n", "<leader>q", ":q!<CR>", opts)
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)
keymap(
	"n",
	"<leader>f",
	":lua require('plugins.telescope').project_files()<cr>",
	opts
)
keymap("n", "<Leader>F", "<CMD>lua require('plugins.telescope.pickers.multi-rg')()<CR>")
keymap("n", "<leader>P", ":lua require('telescope').extensions.projects.projects()<cr>", opts)

keymap('n', '<leader>sw', '<leader>saiw', { remap = true })
keymap('n', '<leader>sW', '<leader>saiW', { remap = true })
-- Replace qoutes
local qoutes = { "'", '"', '`' }
for _, char in ipairs(qoutes) do
	keymap('n', "<leader>" .. char, '<leader>srq' .. char, { remap = true }) -- <leader>{char} to replace sandwich to {char}
end

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- surround-nvim
keymap("n", '<Leader>"', 'ysiW"', { remap = true })
keymap("n", "<Leader>'", "ysiW'", { remap = true })

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts)

-- Simpler command mode
keymap("n", ",", ":", { noremap = true })


-- H to move to the first non-blank character of the line
-- L to move to the last non-blank character of the line
keymap("n", "H", "^", silent)
keymap("n", "L", "$", silent)
keymap("n", "m", "%", silent)
keymap("n", "R", ":%s///gI<left><left><left>", { noremap = true })

-- Half-page jumps, cursos stays in the center
keymap("n", "<C-d>", "<C-d>zz", silent)
keymap("n", "<C-u>", "<C-u>zz", silent)

-- Contol p/P will not paste last deleted text
keymap("n", "C-p>", '"0P', { noremap = true })
keymap("n", "<C-P>", '"0p', { noremap = true })

-- Search result stays in the center
keymap("n", "n", "nzzzv", silent)
keymap("n", "N", "Nzzzv", silent)

-- Keep visual mode indenting
keymap("v", "<", "<gv", silent)
keymap("v", ">", ">gv", silent)

-- Case change in visual mode
keymap("v", "`", "u", silent)
keymap("v", "<A-`>", "U", silent)

-- Save file by CTRL-S
keymap("n", "<C-s>", ":w<CR>", silent)
keymap("i", "<C-s>", "<ESC> :w<CR>", silent)

-- Find word/file across project
keymap("n", "<Leader>pf",
	"<CMD>lua require('plugins.telescope').project_files({ default_text = vim.fn.expand('<cword>'), initial_mode = 'normal' })<CR>")
keymap("n", "<Leader>pw", "<CMD>lua require('telescope.builtin').grep_string({ initial_mode = 'normal' })<CR>")

-- Don't yank on delete char
keymap("n", "x", '"_x', silent)
keymap("n", "X", '"_X', silent)
keymap("v", "x", '"_x', silent)
keymap("v", "X", '"_X', silent)

-- Avoid issues because of remapping <c-a> and <c-x> below
vim.cmd [[
  nnoremap <Plug>SpeedDatingFallbackUp <c-a>
  nnoremap <Plug>SpeedDatingFallbackDown <c-x>
]]

-- Quickfix
keymap("n", "<Space>,", ":cp<CR>", silent)
keymap("n", "<Space>.", ":cn<CR>", silent)

-- Toggle quicklist
keymap("n", "<leader>q", "<cmd>lua require('utils').toggle_quicklist()<CR>", silent)

-- Easyalign
keymap("n", "ga", "<Plug>(EasyAlign)", silent)
keymap("x", "ga", "<Plug>(EasyAlign)", silent)

-- Manually invoke speeddating in case switch.vim didn't work
keymap("n", "<C-a>", ":if !switch#Switch() <bar> call speeddating#increment(v:count1) <bar> endif<CR>", silent)
keymap("n", "<C-x>", ":if !switch#Switch({'reverse': 1}) <bar> call speeddating#increment(-v:count1) <bar> endif<CR>",
	silent)

-- Open links under cursor in browser with gx
if vim.fn.has('macunix') == 1 then
	keymap("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", silent)
else
	keymap("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape('<cWORD>')<CR>", silent)
end

-- Refactor with spectre
keymap("n", "<Leader>pr", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", silent)
keymap("v", "<Leader>pr", "<cmd>lua require('spectre').open_visual()<CR>")

-- LSP
-- keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", silent)
-- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>", silent)
keymap("n", "<C-Space>", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
keymap("v", "<leader>ca", "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>", silent)
keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", silent)
keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", silent)
keymap("v", "<leader>cf", "<cmd>'<.'>lua vim.lsp.buf.range_formatting()<CR>", silent)
keymap("n", "<leader>cl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", silent)
keymap("n", "nh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", silent)
keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next({ float = { border = 'rounded', max_width = 100 }})<CR>",
	silent)
keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'rounded', max_width = 100 }})<CR>",
	silent)
keymap("n", "K", function()
	local winid = require('ufo').peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end)

-- Comment Box
keymap("n", "<leader>ac", "<cmd>lua require('comment-box').lbox()<CR>", silent)
keymap("v", "<leader>ac", "<cmd>lua require('comment-box').lbox()<CR>", silent)

-- Git
keymap("n", "<leader>gg", "<cmd>LazyGit<CR>", opts)

--Terminal
keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", opts)

--Lsp
keymap("n", "<leader>lf", "<cmd>LspToggleAutoFormat<CR>", opts)
keymap("n", "<leader>tf", "<cmd>TypescriptFixAll<CR>", opts)
keymap("n", "<leader>ti", "<cmd>TypescriptAddMissingImports<CR>", opts)
keymap("n", "<leader>to", "<cmd>TypescriptOrganizeImports<CR>", opts)
keymap("n", "<leader>tu", "<cmd>TypescriptRemoveUnused<CR>", opts)

--ZenMode
keymap("n", "<leader>z", "<cmd>ZenMode<CR>", opts)
