local M = {}

local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")

M.capabilties =
	vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), blink_cmp.get_lsp_capabilities())

---@param override lsp.ClientCapabilities
M.extend_client_capabilities = function(override)
	return vim.tbl_deep_extend("force", M.capabilties, override)
end

return M
