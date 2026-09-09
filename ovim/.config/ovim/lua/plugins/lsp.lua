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
	},
}

function M.config()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("ovim-lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			-- Essential keymaps for note-taking
			map("K", vim.lsp.buf.hover, "[H]over [D]ocumentation")
			map("gd", function()
				fzf.lsp_definitions({ jump1 = true })
			end, "[G]oto [D]efinition")
			map("gr", function()
				fzf.lsp_references({ includeDeclaration = false })
			end, "[G]oto [R]eferences")
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")

			-- Diagnostics (for markdown linting if enabled)
			map("[d", function()
				vim.diagnostic.jump({ count = -1 })
			end, "Previous Diagnostic")
			map("]d", function()
				vim.diagnostic.jump({ count = 1 })
			end, "Next Diagnostic")
			map("gl", vim.diagnostic.open_float, "Line Diagnostics")
		end,
	})

	-- Minimal diagnostic config for markdown
	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		virtual_text = false, -- Keep notes clean
	})

	-- Use blink.cmp capabilities
	local capabilities = require("blink.cmp").get_lsp_capabilities()

	-- Marksman configuration
	local servers = {
		marksman = {
			-- Marksman works great out of the box for markdown
			-- Optional: add custom settings here if needed
			-- settings = {}
		},
	}

	-- Install marksman automatically
	require("mason-tool-installer").setup({
		ensure_installed = { "marksman" },
	})

	require("mason-lspconfig").setup({
		ensure_installed = { "marksman" },
		automatic_installation = true,
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end

return M
