return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && "
                .. "cmake --build build --config Release && "
                .. "cmake --install build --prefix build"
        }
    },
    init = function()
        require("plugins.telescope.mappings")
    end,
    config = function()
        require("plugins.telescope.cmds")
        require("plugins.telescope.setup").setup()
    end
}
