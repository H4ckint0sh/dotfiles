return {
    -- buffer line
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "bp",        ":BufferLinePick <CR>" },
            { "bd",        ":BufferLinePickClose <CR>" },

            { "bm<Right>", ":BufferLineMoveNext<CR>" },
            { "bm<Left>",  ":BufferLineMovePrev<CR>" },

            { "<tab>",     ":BufferLineCycleNext<CR>" },
            { "<s-tab>",   ":BufferLineCyclePrev<CR>" },

            { "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>" },
            { "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>" },
            { "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>" },
            { "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>" },
            { "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>" },
            { "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>" },
            { "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>" },
            { "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>" },
            { "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>" },
        },
        config = function()
            require("bufferline").setup({
                highlights = {
                    tab = {
                        bold = false,
                        italic = false
                    },
                    tab_selected = {
                        bold = false,
                        italic = false
                    },
                    buffer_visible = {
                        bold = false,
                        italic = false
                    },
                    buffer_selected = {
                        bold = false,
                        italic = false,
                    },
                },
                options = {
                    always_show_bufferline = false,
                    offsets = { { filetype = "NvimTree", text = "File Manager", padding = 1 } },
                    separator_style = "slant",
                    diagnostics = false,
                    show_buffer_icons = false,
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    show_tab_indicators = false,
                    indicator_icon = nil,
                    indicator = { style = "", icon = "" },
                    buffer_close_icon = "",
                    modified_icon = "●",
                    close_icon = "",
                },
            })
        end
    },
}
