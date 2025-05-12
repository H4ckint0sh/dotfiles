vim.lsp.config["astro"] = {
	before_init = function(params, config)
		-- print("THIS IS THE CONFIG BEFORE INIT: " .. vim.inspect(config))
		-- print("THIS IS THE PARAMS BEFORE INIT: " .. vim.inspect(params))
		-- Check if fname is a string, otherwise get the current buffer's filename
		local fname = vim.api.nvim_buf_get_name(0)

		local markers = { "node_modules" }

		local found_file = vim.fs.find(markers, {
			upward = true,
			path = fname,
			stop = vim.env.HOME,
		})[1]

		if found_file then
			local root = vim.fs.dirname(found_file)
			-- print("THIS IS THE ROOT DIR: " .. root)
			local tsdk = root .. "/node_modules/typescript/lib"
			-- print("THIS IS THE TSDK: " .. tsdk)

			config.init_options.typescript = {
				tsdk = tsdk,
			}

			-- print("THIS IS THE CONFIG AFTER INIT: " .. vim.inspect(config.init_options))
		end
	end,
}
