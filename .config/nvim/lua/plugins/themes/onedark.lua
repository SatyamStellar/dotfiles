return {
	"navarasu/onedark.nvim",
	config = function()
		-- Example configuration
		require("onedark").setup({
			style = "darker", -- You can choose from 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
			transparent = false, -- Enable/Disable transparent background
			term_colors = true, -- Enable terminal colors
			ending_tildes = false, -- Show tildes at the end of the buffer
			diagnostics = {
				darker = true,
				undercurl = true,
				background = true,
			},
		})
		require("onedark").load() -- Load the theme
	end,
}
