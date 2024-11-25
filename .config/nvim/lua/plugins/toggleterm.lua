return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		-- Add your custom configuration here
		size = 20,
		open_mapping = [[<leader>\]],
		-- other options
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)
	end,
}
