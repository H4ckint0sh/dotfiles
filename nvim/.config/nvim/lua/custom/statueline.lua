-- Define a function to setup the statusline
local function setup_statusline()
    -- Set the statusline options
    vim.o.laststatus = 2  -- Always show the statusline
    vim.o.statusline =
      '%#StatusLineMode#' ..            -- Mode highlight group
      '%{toupper(mode())}' ..           -- Uppercase mode
      '%#StatusLine# ' ..               -- Separator
      '%{expand("%:~:.")}' ..           -- File path, shortened
      '%=%#StatusLineInfo# ' ..         -- Separator
      '%-8.(%l,%c%V%) ' ..              -- Line, column, virtual column
      '%{&filetype} ' ..                -- File type
      '%{&readonly?"[RO]":""} ' ..      -- Read-only indicator
      '%{&modified?"[+]":""} '          -- Modified indicator
end

-- Call the setup function
setup_statusline()
