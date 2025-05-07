return {
	"williamboman/mason.nvim",
	-- TODO: Upgrade to 2.0.0
	-- Requires mason-lspconfig.nvim 2.0.0
	version = "1.*",
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			-- TODO: Upgrade to 2.0.0
			-- mappings/filetype.lua is removed in 2.0.0
			version = "1.*",
		},
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	opts = {
		registries = {
			"github:mason-org/mason-registry",
			"github:Crashdummyy/mason-registry",
		},
	},
	cmd = "Mason",
}
