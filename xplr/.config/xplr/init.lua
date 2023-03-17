version = '0.20.2'

local home = os.getenv("HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path
  .. ";"
  .. xpm_path
  .. "/?.lua;"
  .. xpm_path
  .. "/?/init.lua"

os.execute(
  string.format(
    "[ -e '%s' ] || git clone '%s' '%s'",
    xpm_path,
    xpm_url,
    xpm_path
  )
)

require("xpm").setup({
  plugins = {

    'dtomvan/xpm.xplr',
    'sayanarijit/fzf.xplr',
    'sayanarijit/tri-pane.xplr',
    'sayanarijit/zoxide.xplr',
    'sayanarijit/trash-cli.xplr',
    'sayanarijit/dua-cli.xplr',
    { 'dtomvan/extra-icons.xplr',
      after = function()
          xplr.config.general.table.row.cols[2] = { format = "custom.icons_dtomvan_col_1" }
      end
    },

  },
  auto_install = true,
  auto_cleanup = true,
})


require("fzf").setup{
  mode = "default",
  key = "ctrl-f",
  bin = "fzf",
  args = "--preview 'bat --style=numbers --color=always --line-range :500 {}'",
  recursive = false,
  enter_dir = false,
}

require("trash-cli").setup{
  trash_bin = "trash-put",
  trash_mode = "delete",
  trash_key = "d",
  restore_bin = "trash-restore",
  restore_mode = "delete",
  restore_key = "r",
  trash_list_bin = "trash-list",
  trash_list_selector = "fzf -m | cut -d' ' -f3-",
}

require("zoxide").setup{
  bin = "zoxide",
  mode = "default",
  key = "Z",
}

-- Just for testing with my plugin
require("dua-cli").setup{
  mode = "default",
  key = "i",
}

require("tri-pane").setup({
  layout_key = "T",
  as_default_layout = true,
  left_pane_width = { Percentage = 13 },
  middle_pane_width = { Percentage = 45 },
  right_pane_width = { Percentage = 35 },
})