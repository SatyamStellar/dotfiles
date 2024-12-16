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

			-- Documentation
			map("K", vim.lsp.buf.hover, "Hover Documentation")
			-- Show line Errors

			map("<leader>E", vim.diagnostic.open_float, "Show Line [E]rrors")
			map("<leader>q", function()
				vim.diagnostic.hide(nil, 0) -- Hide diagnostics for the current buffer
			end, "Close [Q]uickly Diagnostic")
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
		vim.diagnostic.config({
			float = {
				wrap = true, -- Enable text wrapping
				max_width = 80, -- Maximum width of the floating window
				max_height = 20, -- Maximum height of the floating window
				border = "rounded", -- Optional: adds a rounded border to the floating window
				source = "always", -- Always show the source of the diagnostic
			},
		})
		-------------------
		-- Language Servers Configuration
		-------------------
		local servers = {
			-- -- Go
			-- gopls = {
			-- 	settings = {
			-- 		gopls = {
			-- 			analyses = {
			-- 				unusedparams = true,
			-- 				shadow = true,
			-- 				unusedwrite = true,
			-- 				useany = true,
			-- 				nilness = true,
			-- 				structtag = true,
			-- 			},
			-- 			staticcheck = true,
			-- 			gofumpt = true,
			-- 			usePlaceholders = true,
			-- 			hints = {
			-- -- 				assignVariableTypes = true,
			-- 				compositeLiteralFields = true,
			-- 				compositeLiteralTypes = true,
			-- 				constantValues = true,
			-- 				functionTypeParameters = true,
			-- 				parameterNames = true,
			-- 				rangeVariableTypes = true,
			-- 			},
			-- 			codelenses = {
			-- 				gc_details = true,
			-- 				generate = true,
			-- 				regenerate_cgo = true,
			-- 				run_govulncheck = true,
			-- 				test = true,
			-- 				tidy = true,
			-- 				upgrade_dependency = true,
			-- 			},
			-- 			completeUnimported = true,
			-- 			directoryFilters = {
			-- 				"-node_modules",
			-- 				"-vendor",
			-- 			},
			-- 			semanticTokens = true,
			-- -- 			diagnosticsDelay = "500ms",
			-- 		},
			-- 	},
			-- 	-- Add specific formatting setup for Go files
			-- 	on_attach = function(client, bufnr)
			-- 		-- Format on save
			-- 		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 			buffer = bufnr,
			-- 			callback = function()
			-- 				vim.lsp.buf.format({ async = false })
			-- 			end,
			-- 		})
			-- 	end,
			-- },

			-- -- Python
			-- ruff = {},
			-- pylsp = {
			-- 	settings = {
			-- 		pylsp = {
			-- 			plugins = {
			-- 				pyflakes = { enabled = false },
			-- 				pycodestyle = { enabled = false },
			-- 				autopep8 = { enabled = false },
			-- 				yapf = { enabled = false },
			-- 				mccabe = { enabled = false },
			-- 				pylsp_mypy = { enabled = false },
			-- 				pylsp_black = { enabled = false },
			-- 				pylsp_isort = { enabled = false },
			-- 			},
			-- 		},
			-- 	},
			-- },

			-- C/C++
			clangd = {},

			-- Rust
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						-- Enable inlay hints
						inlayHints = {
							enable = true,
							bindingModeHints = {
								enable = true,
							},
							chainingHints = {
								enable = true,
							},
							closingBraceHints = {
								enable = true,
								minLines = 0,
							},
							lifetimeElisionHints = {
								enable = "skip_trivial",
								useParameterNames = true,
							},
							parameterHints = {
								enable = true,
							},
							reborrowHints = {
								enable = "always",
							},
							renderColons = true,
							typeHints = {
								enable = true,
								hideClosureInitialization = false,
								hideNamedConstructor = false,
							},
							expressionAdjustmentHints = {
								enable = "always",
							},
						},

						-- Additional configurations to enhance type inference
						assist = {
							importEnforceGranularity = true,
							importPrefix = "by_self",
						},

						-- Ensure code actions and completions are comprehensive
						completion = {
							autoimport = {
								enable = true,
							},
							privateEditable = {
								enable = true,
							},
						},

						-- Keep the existing clippy check
						checkOnSave = {
							command = "clippy",
						},
					},
				},
				-- Optional: Add an on_attach function to toggle inlay hints
				on_attach = function(client, bufnr)
					-- Toggle inlay hints with a keybinding
					vim.keymap.set("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
					end, { buffer = bufnr, desc = "LSP: [T]oggle Inlay [H]ints" })
				end,
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
				on_attach = function(client, bufnr)
					-- Format on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
						callback = function()
							vim.cmd("silent! lua vim.lsp.buf.format()")
						end,
						group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
					})
				end,
			},

			-- ESLint
			eslint = {
				settings = {
					packageManager = "npm",
				},
				on_attach = function(client, bufnr)
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
			-- -- C#
			-- omnisharp = {
			-- 	cmd = { "omnisharp" },
			-- 	enable_roslyn_analyzers = true,
			-- 	organize_imports_on_format = true,
			-- 	enable_import_completion = true,
			-- },
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
		local ensure_installed = {
			-- Go tools
			"gopls", -- LSP server
			"golangci-lint", -- Linter
			"gofumpt", -- Stricter formatter
			"gotests", -- Test generation
			"gomodifytags", -- Modify struct tags
			"impl", -- Interface implementation generator
			"delve", -- Debugger
			"staticcheck", -- Static analysis

			-- Other language tools
			"stylua",
			"typescript-language-server",
			"prettierd",
			"prettier",
			"eslint-lsp",
			"rust-analyzer",
			"clangd",
			--"omnisharp",
			"netcoredbg",
			--"csharpier",
		}

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

		-- Add format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end,
}
