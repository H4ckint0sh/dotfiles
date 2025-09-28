local keymap = vim.keymap

keymap.set("n", "<leader>z", "<cmd>RunCommand btop<CR>", { desc = "Open btop in floating terminal" })

-- same behavior like alt + up/down in vscode
-- the selected line will move one line up/down
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Sele
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

-- Comment
keymap.set("n", "<leader>/", "gcc", { remap = true })
keymap.set("v", "<leader>/", "gcc", { remap = true })

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

keymap.set("n", "<BS>", "^", { desc = "move to first non-blank character of the line" })
-- Search
keymap.set("n", "<leaer>ss", ":s/\\v", { silent = false, desc = "search and replace on line" })
keymap.set("n", "<leaer>SS", ":%s/\\v", { silent = false, desc = "search and replace in file" })
keymap.set("n", "R", ":%s/\\v/g<left><left>", { silent = false }) -- replace
keymap.set("v", "<leader>;", ":s/\\%V") -- Search only in visual selection usingb%V atom
keymap.set("v", "<leader>w", '"hy:%s/\\v<C-r>h//g<left><left>', { silent = false }) -- change selection
-- Search and replace
keymap.set({ "n", "v" }, "<leader>rr", [[:%s///gcI<Left><Left><Left><Left><Left>]], { desc = "Replace in Buffer" })
keymap.set(
	"n",
	"<leader>rw",
	[[:%s/\<<C-r><C-w>\>//gcI<Left><Left><Left><Left>]],
	{ desc = "Replace in Buffer (Word)" }
)
keymap.set("v", "<leader>rs", [[:s///gcI<Left><Left><Left><Left><Left>]], { desc = "Replace in Selection" })
keymap.set(
	"n",
	"<leader>rR",
	[[:cfdo %s///gcI | update]]
		.. [[<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
	{ desc = "Replace in Quickfix List" }
)
keymap.set(
	"n",
	"<leader>rW",
	[[:cfdo %s/\<<C-r><C-w>\>//gcI | update]]
		.. [[<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
	{ desc = "Replace in Quickfix List (Word)" }
)

keymap.set("n", "<leader>:", function()
	Snacks.picker.command_history({
		layout = {
			preset = "select",
			layout = { width = 0.4, min_width = 60, border = "rounded", height = 0.4, min_height = 17 },
		},
	})
end, { desc = "Command History" })

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
keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>") -- Rename Symbol
keymap.set("n", "<leader>a", '<cmd>lua require("fastaction").code_action()<CR>') -- Code Actions

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

-- Open git modified files directly in buffers
vim.keymap.set("n", "<leader>mf", function()
	-- Check if in git repo
	local git_check = io.popen("git rev-parse --is-inside-work-tree 2>&1")
	local is_git_repo = git_check:read("*a")
	git_check:close()

	if not is_git_repo or is_git_repo:match("fatal:") then
		vim.notify("Not in a git repository", vim.log.levels.WARN)
		return
	end

	-- Get modified files
	local handle = io.popen("git diff --name-only 2>&1")
	if not handle then
		vim.notify("Failed to check git status", vim.log.levels.ERROR)
		return
	end

	local result = handle:read("*a")
	handle:close()

	-- Check for errors
	if result:match("fatal:") then
		vim.notify("Git error: " .. result, vim.log.levels.ERROR)
		return
	end

	-- Process files
	result = result:gsub("^%s*(.-)%s*$", "%1")
	if result == "" then
		vim.notify("No modified files in git repository", vim.log.levels.INFO)
		return
	end

	-- Open each file in a buffer
	local count = 0
	for file in result:gmatch("[^\n]+") do
		if file ~= "" then
			vim.cmd("edit " .. vim.fn.fnameescape(file))
			count = count + 1
		end
	end

	vim.notify(string.format("Opened %d modified files", count), vim.log.levels.INFO)
end, { desc = "Open git modified files in buffers" })
