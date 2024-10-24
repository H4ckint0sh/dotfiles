local keymap = vim.keymap

-- Terminal
-- Define terminal mode mapping in Lua
vim.keymap.set("t", "<S-esc>", "<C-\\><C-n>")

-- Move line up
keymap.set("n", "<A-u>", ":m .-2<cr>==")
keymap.set("i", "<A-u>", "<esc>:m .-2<cr>==gi")
keymap.set("v", "<A-u>", ":m '<-2<CR>gv=gv")

-- Move line down
keymap.set("n", "<A-d>", ":m .+1<CR>==")
keymap.set("i", "<A-d>", "<Esc>:m .+1<CR>==gi")
keymap.set("v", "<A-d>", ":m '>+1<CR>gv=gv")

-- Select whole file
keymap.set("n", "<leader>sa", "ggVG")

-- Keep stuff centred while moving around
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

-- Duplicate line up
keymap.set("n", "<A-S-u>", "yypk")
keymap.set("v", "<A-S-u>", "yP`[V`]")

-- Duplicate line down
keymap.set("n", "<A-S-d>", "yyp")
keymap.set("v", "<A-S-d>", "y`>pgv")

-- move to first non-blank character
keymap.set("n", "<BS>", "^")

-- Highlight to end of line
keymap.set("n", "L", "vg_")

-- paste over whole file
keymap.set("n", "<leader>v", "ggVGp")

-- Remove highlights
keymap.set("n", "<CR>", ":noh<CR><CR>", { silent = true })

-- Buffers
keymap.set("n", "<leader>x", ":bd<CR>")

-- Redo
keymap.set("n", "<S-u>", ":redo<CR>", { silent = true })

-- Save
keymap.set("n", "<leader>w", ":w<CR>", { silent = true })

-- Search
keymap.set("n", "R", ":%s/\\v/g<left><left>", { silent = false }) -- replace
keymap.set("n", "ss", ":s/", { silent = false }) -- search and replace
keymap.set("n", "SS", ":%s/\\v", { silent = false }) -- search and replace
keymap.set("v", "<leader><C-r>", ":s/\\%V") -- Search only in visual selection usingb%V atom
keymap.set("v", "<C-r>", '"hy:%s/\\v<C-r>h//g<left><left>', { silent = false }) -- change selection

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

-- Keybindings for LSP functionalities
keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>") -- Go to Definition
keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>") -- Go to Implementation
keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>") -- Rename Symbol
keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>") -- Code Actions
keymap.set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>") -- Type Definition
keymap.set("n", "sh", "<cmd>lua vim.lsp.buf.signature_help()<CR>") -- Signature Help
keymap.set("n", "<leader>f", require("fzf-lua").files, { desc = "Fzf Files" })
keymap.set("n", "<leader>R", require("fzf-lua").registers, { desc = "Registers" })
keymap.set("n", "<leader>m", require("fzf-lua").marks, { desc = "Marks" })
keymap.set("n", "<leader>h", require("fzf-lua").oldfiles, { desc = "Recent files" })
keymap.set("n", "<leader>t", require("fzf-lua").live_grep, { desc = "Fzf Grep" })
keymap.set("n", "<leader>y", require("fzf-lua").live_grep_glob, { desc = "Fzf Grep" })
keymap.set("n", "<leader>b", require("fzf-lua").buffers, { desc = "Fzf Buffers" })
keymap.set("n", "<leader>j", require("fzf-lua").helptags, { desc = "Help Tags" })
keymap.set("n", "<leader>gf", require("fzf-lua").git_status, { desc = "Git Status" })
keymap.set("n", "<leader>d", "<cmd>FzfLua lsp_document_diagnostics<CR>")
keymap.set("n", "<leader>D", "<cmd>FzfLua lsp_workspace_diagnostics<CR>")
keymap.set("n", "<leader>gs", "<cmd>FzfLua lsp_document_symbols<CR>", {})
keymap.set("n", "<leader>gr", "<cmd>FzfLua lsp_references<CR>", {})
keymap.set("n", "<leader>'", "<cmd>FzfLua resume<cr>", { desc = "Resume" })
