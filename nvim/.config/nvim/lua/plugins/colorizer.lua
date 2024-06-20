return {
    "NvChad/nvim-colorizer.lua",
    config = function ()
require 'colorizer'.setup({
  filetypes = {
    'html',
    'css',
    'javascript',
    'typescript',
    'typescriptreact',
    'javascriptreact',
    'lua'
  },
  user_default_options = {
    mode = "background",
    tailwind = false, -- Enable tailwind colors
  }
})
    end
}
