return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- Makes sure Gruvbox loads first
    config = function()
        -- Set background to dark mode
        vim.o.background = "dark" -- or "light" for light mode

        -- Set up Gruvbox with some custom options
        require("gruvbox").setup({
            terminal_colors = true,
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            inverse = true, -- Invert background for search, diffs, statuslines, and errors
            contrast = "",  -- Options: "hard", "soft", or empty string for default contrast
            dim_inactive = false,
            transparent_mode = true,
        })

        -- Apply the Gruvbox colorscheme
        vim.cmd([[colorscheme gruvbox]])
    end
}