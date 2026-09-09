local M = {
	"stevearc/conform.nvim",
	dependencies = {
		"mfussenegger/nvim-lint",
	},
	event = { "BufReadPost", "BufNewFile" }, -- load on real file open, not at startup
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "Format buffer",
		},
	},
}

function M.config()
	local conform = require("conform")
	local lint = require("lint")

	-- ── Linting (nvim-lint) ──────────────────────────────────────────────────
	lint.linters_by_ft = {
		javascript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		typescript = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		python = { "ruff" },
		go = { "golangcilint" },
		sh = { "shellcheck" },
	}

	-- Debounced lint trigger — avoids hammering on every keystroke in InsertLeave
	local lint_timer = vim.uv.new_timer()
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		callback = function()
			lint_timer:stop()
			lint_timer:start(
				100,
				0,
				vim.schedule_wrap(function()
					lint.try_lint()
				end)
			)
		end,
	})

	-- ── Formatting (conform.nvim) ────────────────────────────────────────────
	conform.setup({
		default_format_opts = {
			timeout_ms = 3000,
			async = false,
			quiet = false,
			lsp_format = "fallback",
		},

		formatters_by_ft = {
			-- Web
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			jsonc = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			ocaml = { "ocamlformat" },

			-- Go (order matters: fix style → sort imports → wrap long lines)
			go = { "gofumpt", "goimports_reviser", "golines" },

			-- Python (order matters: fix lint → format → sort imports)
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },

			-- Lua
			lua = { "stylua" },

			-- Shell
			sh = { "shfmt" },
		},

		formatters = {
			shfmt = {
				prepend_args = { "-i", "4", "-ci" }, -- 4-space indent, indent switch cases
			},
			golines = {
				prepend_args = { "--max-len=120" },
			},
		},
	})
end

return M
