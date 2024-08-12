vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use node 20 for all LSPs and so on
vim.env.PATH = "~/.nvm/versions/node/v20.14.0/bin:" .. vim.env.PATH

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy with dynamic loading of anything in the plugins directory
require("lazy").setup("plugins", {
	change_detection = {
		enabled = true, -- automatically check for config file changes and reload the ui
		notify = false, -- turn off notifications whenever plugin changes are made
	},
})

-- Utils
require("util")
require("util.globals")

-- Statusline
require("custom.statusline")
require("custom.substitute") -- Substitutes in the statusline

-- LSP
require("lsp.config")
require("lsp.setup")
require("lsp.functions")

-- These modules are not loaded by lazy
require("core.autocmds")
require("core.options")
require("core.keymaps")
