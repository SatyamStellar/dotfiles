-- Core LSP setup with dependencies
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Mason: LSP installer and manager
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- UI and completion integration
		{ "j-hui/fidget.nvim", opts = {} }, -- LSP status updates
		"hrsh7th/cmp-nvim-lsp", -- LSP completion capabilities
	},
	config = function()
		-------------------
		-- LSP Keybindings
		-------------------
		local function setup_lsp_keymaps(event)
			local function map(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			-- Navigation
			map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
			map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
			map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

			-- Symbol search
			map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
			map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

			-- Code actions
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
		end

		-------------------
		-- LSP Highlighting
		-------------------
		local function setup_document_highlight(event, client)
			if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
				local highlight_group = vim.api.nvim_create_augroup("lsp-document-highlight", { clear = false })

				-- Highlight references when cursor holds
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_group,
					callback = vim.lsp.buf.document_highlight,
				})

				-- Clear highlights when cursor moves
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_group,
					callback = vim.lsp.buf.clear_references,
				})

				-- Clean up on LSP detach
				vim.api.nvim_create_autocmd("LspDetach", {
					buffer = event.buf,
					callback = function(args)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = args.buf })
					end,
				})
			end
		end

		-------------------
		-- Language Servers Configuration
		-------------------
		local servers = {
			-- Python
			ruff = {},
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							-- Disable conflicting plugins
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = false },
							pylsp_mypy = { enabled = false },
							pylsp_black = { enabled = false },
							pylsp_isort = { enabled = false },
						},
					},
				},
			},
			-- C
			clangd = {},

			-- Rust
			rust_analyzer = {
				-- cmd = { "/run/current-system/sw/bin/rust-analyzer" }, --nixos
				settings = {
					["rust-analyzer"] = {
						checkOnSave = { command = "clippy" },
					},
				},
			},

			-- Web Development
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = {},

			-- Infrastructure and Data
			dockerls = {},
			sqlls = {},
			terraformls = {},
			jsonls = {},
			yamlls = {},
			-- TypeScript/JavaScript
			ts_ls = {
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},

			-- ESLint
			eslint = {
				settings = {
					-- Specify package manager if needed
					packageManager = "npm",
				},
				on_attach = function(client, bufnr)
					-- Enable formatting
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			},

			-- Lua
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
						diagnostics = { disable = { "missing-fields" } },
						format = { enable = false },
					},
				},
			},
		}

		-------------------
		-- LSP Setup
		-------------------
		-- Set up capabilities with nvim-cmp integration
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		-- Ensure tools are installed
		local ensure_installed = vim.tbl_keys(servers)
		table.insert(ensure_installed, {
			"stylua",
			"typescript-language-server",
			"prettierd",
			"eslint-lsp",
			"rust-analyzer",
			"clangd",
		}) -- Lua formatter

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Set up language servers
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		-- Set up autocommands for LSP attachments
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- Set up keymaps
				setup_lsp_keymaps(event)

				-- Set up document highlighting
				setup_document_highlight(event, client)

				-- Set up auto-formatting for Rust
				if vim.bo[event.buf].filetype == "rust" then
					vim.api.nvim_create_autocmd("BufWritePre", {
						-- pattern = { "*.ts,", "*.tsx", "*.js", "*.jsx" },
						buffer = event.buf,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end

				-- Set up inlay hints toggle if supported
				if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					vim.keymap.set("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, { buffer = event.buf, desc = "LSP: [T]oggle Inlay [H]ints" })
				end
			end,
		})
	end,
}
