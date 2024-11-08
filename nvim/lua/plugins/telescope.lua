return {
  'nvim-telescope/telescope.nvim',
  lazy = false,
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",    -- Move down in the list
            ["<C-k>"] = "move_selection_previous" -- Move up in the list
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
        },
        live_grep = {
          theme = "dropdown",
          previewer = false,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
        }
      }
    })

    -- Key mappings
    local keymap = vim.keymap.set
    keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
    keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
    keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
    keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Find help tags" })
    keymap("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Find keymaps" })
  end,
}
