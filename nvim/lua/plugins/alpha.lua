return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.startify'

    -- Centering the header ASCII art
    dashboard.section.header.val = {
      [[ _________  __           .__   .__                   ]],
      [[ /   _____/_/  |_   ____  |  |  |  |  _____   _______ ]],
      [[ \_____  \ \   __\_/ __ \ |  |  |  |  \__  \  \_  __ \]],
      [[ /        \ |  |  \  ___/ |  |__|  |__ / __ \_ |  | \/]],
      [[/_______  / |__|   \___  >|____/|____/(____  / |__|   ]],
      [[        \/             \/                  \/         ]],
      [[      ░▒▓███ Embrace the Cosmos of Code ███▓▒░        ]],
    }
    dashboard.section.header.opts = { position = "center" }



    -- Apply the centered configuration
    alpha.setup(dashboard.opts)
  end,
}
