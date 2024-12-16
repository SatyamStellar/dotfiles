return {
	"kyazdani42/nvim-web-devicons",
	lazy = false, -- Change to lazy = false to ensure it loads
	config = function()
		local devicons = require("nvim-web-devicons")
		devicons.setup({
			override = {
				-- You can override specific icons here if needed
			},
			default = true,
		})

		-- Debug: Print all supported icons
		print(vim.inspect(devicons.get_icons()))
	end,
}
