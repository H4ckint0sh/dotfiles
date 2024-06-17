-- Define function to setup tabline
local function setup_tabline()
    -- Enable the tabline
    vim.o.showtabline = 2  -- Always show the tab line

    -- Define a custom function for the tabline
    function _G.MyTabLine()
        local s = ''
        local buffers = vim.fn.getbufinfo({buflisted = 1})
        for i, buffer in ipairs(buffers) do
            -- Select the highlight group
            if buffer.bufnr == vim.fn.bufnr() then
                s = s .. '%#TabLineSel#'
            else
                s = s .. '%#TabLine#'
            end

            -- Add the sequential index and buffer name
            s = s .. '%' .. i .. 'T ' .. i .. ': ' .. vim.fn.fnamemodify(buffer.name, ':t') .. ' '
        end
        -- Right-align the fill section
        s = s .. '%#TabLineFill#%T'
        return s
    end

    -- Set the tabline to use the custom function
    vim.o.tabline = '%!v:lua.MyTabLine()'
end

-- Define function to setup key mappings
local function setup_keymappings()
    -- Key mappings for navigating buffers
    vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

    -- Function to switch to a specific buffer
    function _G.SwitchToBuffer(index)
        local buffers = vim.fn.getbufinfo({buflisted = 1})
        if index >= 1 and index <= #buffers then
            vim.cmd('buffer ' .. buffers[index].bufnr)
        else
            -- Display message in red text
            vim.cmd('echohl ErrorMsg | echo "Invalid buffer number" | echohl NONE')
         end
    end

    -- Key mappings for jumping to specific buffer numbers
    for i = 1, 9 do
        vim.api.nvim_set_keymap('n', '<leader>' .. i, ':lua SwitchToBuffer(' .. i .. ')<CR>', { noremap = true, silent = true })
    end
end

-- Call setup functions
setup_tabline()
setup_keymappings()

-- Make the buffer line and other elements transparent
vim.cmd [[
  hi TabLine guibg=NONE ctermbg=NONE
  hi TabLineSel guibg=NONE ctermbg=NONE
  hi TabLineFill guibg=NONE ctermbg=NONE
]]

