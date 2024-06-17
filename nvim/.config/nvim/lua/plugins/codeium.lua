return {
    "jcdickinson/codeium.nvim",
    cond = true,
    event = "InsertEnter",
    cmd = "Codeium",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = true,
}
