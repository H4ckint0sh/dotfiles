return {
    "laytan/tailwind-sorter.nvim",
    cmd = {
        "TailwindSort",
        "TailwindSortOnSaveToggle"
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    build = "cd formatter && npm i && npm run build",
    config = true,
}
