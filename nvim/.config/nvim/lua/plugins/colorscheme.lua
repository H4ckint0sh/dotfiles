-- Catppuccin Theme
 return {
   -- https://github.com/catppuccin/nvim
   'catppuccin/nvim',
   name = "catppuccin", -- name is needed otherwise plugin shows up as "nvim" due to github URI
   lazy = false, -- We want the colorscheme to load immediately when starting Neovim
   priority = 1000, -- Load the colorscheme before other non-lazy-loaded plugins
   opts = {
   --   -- Replace this with your scheme-specific settings or remove to use the defaults
     -- transparent = true,
     flavour = "mocha", -- "latte, frappe, macchiato, mocha"
     styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
   },
   config = function(_, opts)
     require('catppuccin').setup(opts) -- Replace this with your favorite colorscheme
     vim.cmd("colorscheme catppuccin") -- Replace this with your favorite colorscheme
   end
 }

