-- Indentation guides
return {
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    "lukas-reineke/indent-blankline.nvim",
    event = 'VeryLazy',
    main = "ibl",
    opts = {
        enabled = true,
        exclude = {
            filetypes = { "help", "dashboard", "packer", "Trouble", "TelescopePrompt", "Float" },
            buftypes = { "terminal", "nofile", "telescope" },
        },
        indent = {
            char = "│",
        },
        scope = {
            enabled = true,
            show_start = false,
        }
    },
}
