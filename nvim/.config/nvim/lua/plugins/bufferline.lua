return {
    -- buffer line
    {
        "akinsho/bufferline.nvim",
        keys = {
            { "bp",        ":BufferLinePick <CR>" },
            { "bd",        ":BufferLinePickClose <CR>" },
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
            local bufferline = require("bufferline")
            bufferline.setup({
                options = {
                    mode = 'buffers',
                    numbers = "buffer_id",
                    max_name_length = 15,
                    max_prefix_length = 12, -- prefix used when a buffer is de-duplicated
                    truncate_names = true,  -- whether or not tab names should be truncated
                    tab_size = 15,
                    separator_style = 'thin',
                    always_show_bufferline = false,
                    offsets = { { filetype = "NvimTree", text = "File Manager", separator = true, } },
                    style_preset = {
                        bufferline.style_preset.no_italic,
                        bufferline.style_preset.no_bold,
                        bufferline.style_preset.minimal,
                    },
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
