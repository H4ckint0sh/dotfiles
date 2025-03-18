local lsp_custom = require("core.lsp.custom")
local keymap = vim.keymap

-- same behavior like alt + up/down in vscode
-- the selected line will move one line up/down
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Select whole file
keymap.set("n", "<leader>sa", "ggVG")

-- Keep stuff centred while moving around
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Keep things highlighted after moving with < and >
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Duplicate line(s) up
keymap.set("i", "<S-A-Up>", "<Esc>yypki")
keymap.set("n", "<S-A-Up>", "yypk")
keymap.set("v", "<S-A-Up>", "yP`[V`]")

-- Duplicate line(s) down
keymap.set("i", "<S-A-Down>", "<Esc>yypi")
keymap.set("n", "<S-A-Down>", "yyp")
keymap.set("v", "<S-A-Down>", "y`>pgv")

-- move to first non-blank character
keymap.set("n", "<BS>", "^")

-- Highlight to end of line
keymap.set("n", "L", "vg_")

-- Dont copy the deleted text
keymap.set("n", "x", '"_x')

-- Y to yank to end of line
keymap.set("n", "Y", "y$")

-- Easy repeat of q@
keymap.set("n", "Q", "@q")

-- Scape to normal mode from terminal mode
keymap.set("t", "<esc><esc>", "<C-\\><C-n>")

-- paste over whole file
keymap.set("n", "<leader>v", function()
	vim.cmd("normal! ggVGp")
end, { desc = "Paste over entire buffer" })

-- Remove highlights
vim.keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>")

-- Removie console.log
keymap.set("n", "<leader>cl", ":%g/console.log/d<CR>")

-- Redo
keymap.set("n", "<S-u>", ":redo<CR>", { silent = true })

-- Save
keymap.set("n", "<leader>w", ":w<CR>", { silent = true })

-- Search
keymap.set("n", "R", ":%s/\\v/g<left><left>", { silent = false }) -- replace
keymap.set("n", "ss", ":s/", { silent = false }) -- search and replace
keymap.set("n", "SS", ":%s/\\v", { silent = false }) -- search and replace
keymap.set("v", "<leader>;", ":s/\\%V") -- Search only in visual selection usingb%V atom
keymap.set("v", "<leader>w", '"hy:%s/\\v<C-r>h//g<left><left>', { silent = false }) -- change selection

-- General keymaps
keymap.set("n", "<leader>%", "ggVG") -- exit insert mode with ii
keymap.set("n", "<leader>wq", ":wq<CR>") -- save and quit
keymap.set("n", "<leader>qq", ":q!<CR>") -- quit without saving
keymap.set("n", "<leader>ww", ":w<CR>") -- save
keymap.set("n", "gx", ":!open <c-r><c-a><CR>") -- open URL under cursor

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>") -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>") -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>") -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>") -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

-- got to previuos active tab
keymap.set("n", "<leader>#", ":b#<CR>")

-- Git-blame
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>") -- toggle git blame

keymap.set("n", "<leader>o", vim.diagnostic.open_float, { noremap = true, silent = true })

-- Keybindings for LSP functionalities
keymap.set("n", "gd", lsp_custom.definition) -- Go to Definition
keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>") -- Go to Implementation
keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>") -- Rename Symbol
keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>") -- Code Actions
keymap.set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>") -- Type Definition
keymap.set("n", "sh", "<cmd>lua vim.lsp.buf.signature_help()<CR>") -- Signature Help

-- Keybindings for vim.diagnostic
keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = false })
end, { desc = "Prev diagnostic" })
keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = false })
end, { desc = "Next diagnostic" })
keymap.set("n", "[e", function()
	vim.diagnostic.jump({
		count = -1,
		enable_popup = false,
		severity = vim.diagnostic.severity.ERROR,
	})
end, { desc = "Prev error" })
keymap.set("n", "]e", function()
	vim.diagnostic.jump({
		count = 1,
		enable_popup = false,
		severity = vim.diagnostic.severity.ERROR,
	})
end, { desc = "Next error" })
keymap.set("n", "[w", function()
	vim.diagnostic.jump({
		count = -1,
		enable_popup = false,
		severity = vim.diagnostic.severity.WARN,
	})
end, { desc = "Prev warning" })
keymap.set("n", "]w", function()
	vim.diagnostic.jump({
		count = 1,
		enable_popup = false,
		severity = vim.diagnostic.severity.WARN,
	})
end, { desc = "Next warning" })
