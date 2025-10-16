local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
	defaults = { lazy = false },
	checker = { enabled = true },
	concurrency = 5,
	debug = false,
	ui = {
		border = "rounded",
		-- The backdrop opacity. 0 is fully opaque, 100 is fully transparent.
		backdrop = 100,
	},
})

vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>")
