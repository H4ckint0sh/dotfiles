return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { -- stylua: ignore
				"nvim-neotest/nvim-nio",
			},
		},
		-- Shows virtual text for the current line's breakpoints
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },

		"mxsdev/nvim-dap-vscode-js",
		-- build debugger from source

		-- -- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	keys = {
		-- normal mode is default
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
		},
		{
			"<leader>dO",
			function()
				require("dap").step_out()
			end,
		},
	},
	config = function()
		require("mason-nvim-dap").setup({
			ensure_installed = {
				"js",
			},

			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},
		})

		require("dap-vscode-js").setup({
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
		})

		require("dapui").setup({})
		local dap, dapui = require("dap"), require("dapui")
		dap.set_log_level("DEBUG")
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({ reset = true })
		end
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
			dap.adapters[adapter] = {
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = "js-debug-adapter",
					args = { "${port}" },
				},
			}
		end

		for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch (Node)",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "bunx",
					runtimeArgs = { "tsx" },
				},
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch (Chrome)",
					url = "http://localhost:3000",
					sourceMaps = true,
					webRoot = "${workspaceFolder}",
					protocol = "inspector",
					skipFiles = { "**/node_modules/**/*" },
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach (Node)",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
					skipFiles = { "${workspaceFolder}/node_modules/**/*" },
				},
			}
		end

		vim.keymap.set("n", "<leader>du", function()
			dapui.toggle()
		end)
	end,
}
