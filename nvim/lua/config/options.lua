local opt = vim.opt

opt.number = true                          -- Make line numbers default (default: false)
opt.relativenumber = true                  -- Set relative numbered lines (default: false)
opt.clipboard = 'unnamedplus'              -- Sync clipboard between OS and Neovim. (default: '')
opt.wrap = false                           -- Display lines as one long line (default: true)
opt.linebreak = true                       -- Companion to wrap, don't split words (default: false)
opt.mouse = 'a'                            -- Enable mouse mode (default: '')
opt.autoindent = true                      -- Copy indent from current line when starting new one (default: true)
opt.ignorecase = true                      -- Case-insensitive searching UNLESS \C or capital in search (default: false)
opt.smartcase = true                       -- Smart case (default: false)
opt.shiftwidth = 4                         -- The number of spaces inserted for each indentation (default: 8)
opt.tabstop = 4                            -- Insert n spaces for a tab (default: 8)
opt.softtabstop = 4                        -- Number of spaces that a tab counts for while performing editing operations (default: 0)
opt.expandtab = true                       -- Convert tabs to spaces (default: false)
opt.scrolloff = 4                          -- Minimal number of screen lines to keep above and below the cursor (default: 0)
opt.sidescrolloff = 8                      -- Minimal number of screen columns either side of cursor if wrap is `false` (default: 0)
opt.cursorline = false                     -- Highlight the current line (default: false)
opt.splitbelow = true                      -- Force all horizontal splits to go below current window (default: false)
opt.splitright = true                      -- Force all vertical splits to go to the right of current window (default: false)
opt.hlsearch = false                       -- Set highlight on search (default: true)
opt.showmode = false                       -- We don't need to see things like -- INSERT -- anymore (default: true)
opt.termguicolors = true                   -- Set termguicolors to enable highlight groups (default: false)
opt.whichwrap =
'bs<>[]hl'                                 -- Which "horizontal" keys are allowed to travel to prev/next line (default: 'b,s')
opt.numberwidth = 4                        -- Set number column width to 2 {default 4} (default: 4)
opt.swapfile = false                       -- Creates a swapfile (default: true)
opt.smartindent = true                     -- Make indenting smarter again (default: false)
opt.showtabline = 2                        -- Always show tabs (default: 1)
opt.backspace = 'indent,eol,start'         -- Allow backspace on (default: 'indent,eol,start')
opt.pumheight = 10                         -- Pop up menu height (default: 0)
opt.conceallevel = 0                       -- So that `` is visible in markdown files (default: 1)
opt.signcolumn = 'yes'                     -- Keep signcolumn on by default (default: 'auto')
opt.fileencoding = 'utf-8'                 -- The encoding written to a file (default: 'utf-8')
opt.cmdheight = 1                          -- More space in the Neovim command line for displaying messages (default: 1)
opt.breakindent = true                     -- Enable break indent (default: false)
opt.updatetime = 250                       -- Decrease update time (default: 4000)
opt.timeoutlen = 300                       -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
opt.backup = false                         -- Creates a backup file (default: false)
opt.writebackup = false                    -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
opt.undofile = true                        -- Save undo history (default: false)
opt.completeopt =
'menuone,noselect'                         -- Set completeopt to have a better completion experience (default: 'menu,preview')
opt.shortmess:append 'c'                   -- Don't give |ins-completion-menu| messages (default: does not include 'c')
opt.iskeyword:append '-'                   -- Hyphenated words recognized by searches (default: does not include '-')
opt.formatoptions:remove { 'c', 'r', 'o' } -- Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. (default: 'croql')
opt.runtimepath:remove '/usr/share/opt.'   -- Separate Vim plugins from Neovim in case Vim still in use (default: includes this path if Vim is installed)
opt.guicursor =
"n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
opt.encoding = "UTF-8"
