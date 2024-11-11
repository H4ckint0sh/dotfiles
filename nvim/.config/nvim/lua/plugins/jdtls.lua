return {
	"mfussenegger/nvim-jdtls",
	dependencies = { "nvim-lua/plenary.nvim" },
	ft = { "java" }, -- Automatically load for Java files
	opts = function()
		local mason_registry = require("mason-registry")
		local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
		return {
			-- Define the root directory using standard lspconfig
			root_dir = require("lspconfig").util.root_pattern(".git", "mvnw", "gradlew"),
			-- Define project name from root directory
			project_name = function(root_dir)
				return root_dir and vim.fs.basename(root_dir)
			end,
			-- Define config and workspace paths
			jdtls_config_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
			end,
			jdtls_workspace_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
			end,
			-- Command for starting jdtls with Lombok support
			cmd = {
				vim.fn.exepath("jdtls"),
				string.format("--jvm-arg=-javaagent:%s", lombok_jar),
			},
			full_cmd = function(opts)
				local fname = vim.api.nvim_buf_get_name(0)
				local root_dir = opts.root_dir(fname)
				local project_name = opts.project_name(root_dir)
				local cmd = vim.deepcopy(opts.cmd)
				if project_name then
					vim.list_extend(cmd, {
						"-configuration",
						opts.jdtls_config_dir(project_name),
						"-data",
						opts.jdtls_workspace_dir(project_name),
					})
				end
				return cmd
			end,
			dap = { hotcodereplace = "auto", config_overrides = {} },
			dap_main = {},
			test = true,
			settings = {
				java = {
					inlayHints = {
						parameterNames = {
							enabled = "all",
						},
					},
				},
			},
		}
	end,
	config = function(_, opts)
		-- Load extra bundles for nvim-dap if required packages are installed
		local mason_registry = require("mason-registry")
		local bundles = {} ---@type string[]
		if opts.dap and mason_registry.is_installed("java-debug-adapter") then
			local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
			local java_dbg_path = java_dbg_pkg:get_install_path()
			local jar_patterns = {
				java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
			}
			if opts.test and mason_registry.is_installed("java-test") then
				local java_test_pkg = mason_registry.get_package("java-test")
				local java_test_path = java_test_pkg:get_install_path()
				vim.list_extend(jar_patterns, {
					java_test_path .. "/extension/server/*.jar",
				})
			end
			for _, jar_pattern in ipairs(jar_patterns) do
				for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
					table.insert(bundles, bundle)
				end
			end
		end
		local function attach_jdtls()
			local fname = vim.api.nvim_buf_get_name(0)
			local config = vim.tbl_extend("force", {
				cmd = opts.full_cmd(opts),
				root_dir = opts.root_dir(fname),
				init_options = { bundles = bundles },
				settings = opts.settings,
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			}, opts.jdtls or {})
			require("jdtls").start_or_attach(config)
		end
		-- Attach jdtls when a Java file is opened
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = attach_jdtls,
		})
		-- Keymaps for Java LSP actions
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "jdtls" then
					-- Default keymaps
					local buf = args.buf
					vim.api.nvim_buf_set_keymap(
						buf,
						"n",
						"<leader>cxv",
						[[<Cmd>lua require('jdtls').extract_variable_all()<CR>]],
						{ desc = "Extract Variable" }
					)
					vim.api.nvim_buf_set_keymap(
						buf,
						"n",
						"<leader>cxc",
						[[<Cmd>lua require('jdtls').extract_constant()<CR>]],
						{ desc = "Extract Constant" }
					)
					vim.api.nvim_buf_set_keymap(
						buf,
						"n",
						"gs",
						[[<Cmd>lua require('jdtls').super_implementation()<CR>]],
						{ desc = "Goto Super" }
					)
					vim.api.nvim_buf_set_keymap(
						buf,
						"n",
						"<leader>co",
						[[<Cmd>lua require('jdtls').organize_imports()<CR>]],
						{ desc = "Organize Imports" }
					)
					-- Debug and test mappings if nvim-dap is enabled
					if opts.dap and mason_registry.is_installed("java-debug-adapter") then
						require("jdtls").setup_dap(opts.dap)
						if opts.test and mason_registry.is_installed("java-test") then
							vim.api.nvim_buf_set_keymap(
								buf,
								"n",
								"<leader>tt",
								[[<Cmd>lua require('jdtls.dap').test_class()<CR>]],
								{ desc = "Run All Tests" }
							)
							vim.api.nvim_buf_set_keymap(
								buf,
								"n",
								"<leader>tr",
								[[<Cmd>lua require('jdtls.dap').test_nearest_method()<CR>]],
								{ desc = "Run Nearest Test" }
							)
						end
					end
				end
			end,
		})
		-- Attach jdtls initially for the first Java file opened
		attach_jdtls()
	end,
}
