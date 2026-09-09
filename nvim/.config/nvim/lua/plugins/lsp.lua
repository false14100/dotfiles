local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = {
				registries = {
					"github:mason-org/mason-registry",
				},
			},
		},
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true },
		{ "b0o/schemastore.nvim", lazy = true },
	},
}

-- ─── Helpers ────────────────────────────────────────────────────────────────

---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer
---@return boolean
local function client_supports_method(client, method, bufnr)
	if vim.fn.has("nvim-0.11") == 1 then
		return client:supports_method(method, bufnr)
	else
		return client.supports_method(method, { bufnr = bufnr })
	end
end

-- ─── Server Configurations ──────────────────────────────────────────────────
vim.lsp.enable("clangd")
vim.lsp.enable("ocamllsp")

local servers = {

	-- ── JavaScript / TypeScript ─────────────────────────────────────────────
	vtsls = {
		settings = {
			typescript = {
				inlayHints = {
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					variableTypes = { enabled = false },
					propertyDeclarationTypes = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					enumMemberValues = { enabled = true },
				},
				suggest = { completeFunctionCalls = true },
				preferences = {
					importModuleSpecifier = "non-relative",
				},
			},
			javascript = {
				inlayHints = {
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					variableTypes = { enabled = false },
					propertyDeclarationTypes = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					enumMemberValues = { enabled = true },
				},
				suggest = { completeFunctionCalls = true },
			},
		},
	},

	-- ESLint as a language server (provides code actions, fix-on-save support)
	eslint = {
		on_attach = function(_, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "EslintFixAll",
			})
		end,
	},

	-- ── HTML / CSS ──────────────────────────────────────────────────────────
	html = {
		filetypes = { "html", "htmldjango", "eruby" },
	},

	cssls = {
		settings = {
			css = {
				validate = true,
				lint = { unknownAtRules = "ignore" }, -- ignore Tailwind @apply etc.
			},
			scss = { validate = true },
			less = { validate = true },
		},
	},

	tailwindcss = {
		filetypes = {
			"html",
			"css",
			"scss",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		root_dir = function(fname)
			local util = require("lspconfig.util")
			return util.root_pattern(
				"tailwind.config.js",
				"tailwind.config.ts",
				"tailwind.config.cjs",
				"postcss.config.js"
			)(fname)
		end,
		settings = {
			tailwindCSS = {
				validate = true,
				experimental = {
					classRegex = {
						[[class: "([^"]*)]],
						[[class: '([^']*)]],
						[[class="([^"]*)]],
						{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "cva\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					},
				},
			},
		},
	},

	emmet_ls = {
		filetypes = {
			"html",
			"css",
			"scss",
			"sass",
			"less",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		init_options = {
			showAbbreviationSuggestions = true,
			showExpandedAbbreviation = "always",
		},
	},

	-- JSON with schema support
	jsonls = {
		on_new_config = function(new_config)
			local ok, schemastore = pcall(require, "schemastore")
			new_config.settings = {
				json = {
					schemas = ok and schemastore.json.schemas() or {},
					validate = { enable = true },
				},
			}
		end,
	},

	-- ── Python ──────────────────────────────────────────────────────────────
	basedpyright = {
		settings = {
			basedpyright = {
				disableOrganizeImports = true, -- let ruff handle this
				analysis = {
					typeCheckingMode = "standard",
					autoSearchPaths = true,
					autoImportCompletions = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
					ignore = { "*" }, -- let ruff handle all linting
				},
			},
		},
	},

	-- ── Lua (Neovim config) ─────────────────────────────────────────────────
	lua_ls = {
		settings = {
			Lua = {
				completion = { callSnippet = "Replace" },
				diagnostics = { disable = { "missing-fields" } },
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
}

-- ─── Tools (formatters / linters / debuggers) managed by mason-tool-installer
local tools = {
	-- Bash
	"shellcheck",
	"shfmt",
	-- JS/TS
	"eslint_d",
	"prettierd",
	"prettier",
	"emmet-language-server",
	-- Python
	"ruff",
	"debugpy",
	-- Lua
	"stylua",
}

-- ─── Config ─────────────────────────────────────────────────────────────────

function M.config()
	-- ── LspAttach keymaps & features ────────────────────────────────────────
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			local fzf = require("fzf-lua")

			-- Diagnostics
			map("[d", function()
				vim.diagnostic.jump({ count = -1 })
			end, "Previous diagnostic")
			map("]d", function()
				vim.diagnostic.jump({ count = 1 })
			end, "Next diagnostic")
			map("gl", vim.diagnostic.open_float, "Line diagnostics")
			map("<leader>ld", function()
				fzf.diagnostics_document()
			end, "Document diagnostics")

			-- Hover & signature
			map("K", vim.lsp.buf.hover, "Hover documentation")
			map("gs", vim.lsp.buf.signature_help, "Signature help")

			-- Navigation
			map("gd", function()
				fzf.lsp_definitions({ jump1 = true })
			end, "Goto definition")
			map("gD", function()
				fzf.lsp_declarations({ jump1 = true })
			end, "Goto declaration")
			map("gi", function()
				fzf.lsp_implementations({ jump1 = true })
			end, "Goto implementation")
			map("go", function()
				fzf.lsp_typedefs({ jump1 = true })
			end, "Goto type definition")
			map("gr", function()
				fzf.lsp_references({ includeDeclaration = false })
			end, "Goto references")

			-- Actions
			map("<leader>rn", vim.lsp.buf.rename, "Rename")
			map("<leader>ca", function()
				fzf.lsp_code_actions()
			end, "Code action", { "n", "v" })

			-- Symbols
			map("<leader>ds", function()
				fzf.lsp_document_symbols()
			end, "Document symbols")
			map("<leader>ws", function()
				fzf.lsp_workspace_symbols()
			end, "Workspace symbols")

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if not client then
				return
			end

			-- Document highlights (selective filetypes)
			local highlight_ft = {
				javascript = true,
				typescript = true,
				javascriptreact = true,
				typescriptreact = true,
				lua = true,
				python = true,
				go = true,
			}
			local ft = vim.bo[event.buf].filetype
			if
				highlight_ft[ft]
				and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
			then
				local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = hl_group,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = hl_group,
					callback = vim.lsp.buf.clear_references,
				})
				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
					callback = function(ev2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = ev2.buf })
					end,
				})
			end

			-- Inlay hints toggle
			if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "Toggle inlay hints")
			end
		end,
	})

	-- ── Diagnostics ─────────────────────────────────────────────────────────
	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		virtual_text = false,
	})

	-- ── Capabilities ────────────────────────────────────────────────────────
	local capabilities = require("blink.cmp").get_lsp_capabilities()

	-- ── mason-tool-installer ─────────────────────────────────────────────────
	-- Merge server names (mason-lspconfig keys) + standalone tools
	local ensure_installed = vim.tbl_keys(servers)
	vim.list_extend(ensure_installed, tools)

	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	-- ── mason-lspconfig ──────────────────────────────────────────────────────
	require("mason-lspconfig").setup({
		automatic_installation = false,
		handlers = {
			function(server_name)
				local server = vim.tbl_deep_extend("force", {}, servers[server_name] or {})
				server.capabilities = vim.tbl_deep_extend("force", capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end

return M
