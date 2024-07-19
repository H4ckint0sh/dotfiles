-- Set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap

-- init.lua
-- Move line up
keymap.set("n", "<A-u>", ":m .-2<cr>==")
keymap.set("i", "<A-u>", "<esc>:m .-2<cr>==gi")
keymap.set("v", "<A-u>", ":m '<-2<CR>gv=gv")

-- Move line down
keymap.set("n", "<A-d>", ":m .+1<CR>==")
keymap.set("i", "<A-d>", "<Esc>:m .+1<CR>==gi")
keymap.set("v", "<A-d>", ":m '>+1<CR>gv=gv")

-- Select whole file
keymap.set("n", "<leader>%", "ggVG")

-- Keep stuff centred while moving around
keymap.set("n", "*", "*zzzv")
keymap.set("n", "#", "#zzzv")
keymap.set("n", ",", ",zzzv")
keymap.set("n", ";", ";zzzv")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Some fun register stuff
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>Y", '"+y$')
keymap.set("v", "<leader>d", '"_d')
keymap.set("n", "<leader>x", '"_x')
keymap.set("n", "<leader>p", '"_dP')

-- Keep things highlighted after moving with < and >
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- init.lua
-- Duplicate line up
keymap.set("n", "<A-S-u>", "yypk")
keymap.set("v", "<A-S-u>", "yP`[V`]")

-- Duplicate line down
keymap.set("n", "<A-S-d>", "yyp")
keymap.set("v", "<A-S-d>", "y`>pgv")

-- Remove highlights
keymap.set("n", "<CR>", ":noh<CR><CR>")

-- Buffers
keymap.set("n", "<leader>bc", ":bd<CR>")

keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is.enable)
end)

-- Telescope
keymap.set(
	"n",
	"<C-p>",
	':lua require("telescope.builtin").find_files({ hidden = true, find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" }})<CR>'
)
keymap.set("n", "<S-p>", "<CMD>lua require('tele-scope.pickers.multi-rg')()<CR>")

-- Find word/file across project
keymap.set(
	"n",
	"<Leader>pf",
	"<CMD>lua require('plugins.telescope').project_files({ default_text = vim.fn.expand('<cword>'), initial_mode = 'normal' })<CR>"
)
keymap.set("n", "<Leader>pw", "<CMD>lua require('telescope.builtin').grep_string({ initial_mode = 'normal' })<CR>")

-- General keymaps
keymap.set("i", "jk", "<ESC>") -- exit insert mode with jk
keymap.set("i", "ii", "<ESC>") -- exit insert mode with ii
keymap.set("n", "<leader>%", "ggVG") -- exit insert mode with ii
keymap.set("n", "<leader>wq", ":wq<CR>") -- save and quit
keymap.set("n", "<leader>qq", ":q!<CR>") -- quit without saving
keymap.set("n", "<leader>ww", ":w<CR>") -- save
keymap.set("n", "gx", ":!open <c-r><c-a><CR>") -- open URL under cursor

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close split window
keymap.set("n", "<leader>sj", "<C-w>-") -- make split window height shorter
keymap.set("n", "<leader>sk", "<C-w>+") -- make split windows height taller
keymap.set("n", "<leader>sl", "<C-w>>5") -- make split windows width bigger
keymap.set("n", "<leader>sh", "<C-w><5") -- make split windows width smaller

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close a tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- previous tab

-- Diff keymaps
keymap.set("n", "<leader>cc", ":diffput<CR>") -- put diff from current to other during diff
keymap.set("n", "<leader>cj", ":diffget 1<CR>") -- get diff from left (local) during merge
keymap.set("n", "<leader>ck", ":diffget 3<CR>") -- get diff from right (remote) during merge
keymap.set("n", "<leader>cn", "]c") -- next diff hunk
keymap.set("n", "<leader>cp", "[c") -- previous diff hunk

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>") -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>") -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>") -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>") -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

-- Vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle maximize tab

-- Nvim-tree
keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>") -- toggle file explorer
keymap.set("n", "<leader>er", ":NvimTreeFocus<CR>") -- toggle focus to file explorer
keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>") -- find file in file explorer

-- Telescope
--keymap.set('n', '<leader>ff',
--    "<cmd>lua require('telescope.builtin').git_files(require('telescope.themes').get_dropdown({ previewer = false }))<CR>",
--    {})
--keymap.set('n', '<leader>fF', require('telescope.builtin').find_files, {})
--keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
--keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
--keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {})
--keymap.set('n', '<leader>fs', require('telescope.builtin').current_buffer_fuzzy_find, {})
--keymap.set('n', '<leader>fo', require('telescope.builtin').lsp_document_symbols, {})
--keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_incoming_calls, {})
--keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({ default_text = ":method:" }) end)

-- Git-blame
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>") -- toggle git blame

-- Harpoon
keymap.set("n", "<leader>ha", require("harpoon.mark").add_file)
keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu)
keymap.set("n", "<leader>h1", function()
	require("harpoon.ui").nav_file(1)
end)
keymap.set("n", "<leader>h2", function()
	require("harpoon.ui").nav_file(2)
end)
keymap.set("n", "<leader>h3", function()
	require("harpoon.ui").nav_file(3)
end)
keymap.set("n", "<leader>h4", function()
	require("harpoon.ui").nav_file(4)
end)
keymap.set("n", "<leader>h5", function()
	require("harpoon.ui").nav_file(5)
end)
keymap.set("n", "<leader>h6", function()
	require("harpoon.ui").nav_file(6)
end)
keymap.set("n", "<leader>h7", function()
	require("harpoon.ui").nav_file(7)
end)
keymap.set("n", "<leader>h8", function()
	require("harpoon.ui").nav_file(8)
end)
keymap.set("n", "<leader>h9", function()
	require("harpoon.ui").nav_file(9)
end)

-- Vim REST Console
keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>") -- Run REST query

-- LSP
keymap.set("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>")
keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
--keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")
keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("n", "<leader>cf", "<cmd>lua require('lsp.functions').format()<CR>")
keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
keymap.set("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
keymap.set("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
keymap.set("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
keymap.set("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>")
