local M = {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-python",
		"Issafalcon/neotest-dotnet",
	},
	keys = {
		{
			"<leader>tn",
			function()
				require("neotest").run.run()
			end,
			desc = "Test Nearest",
		},
		{
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Test File",
		},
		{
			"<leader>ts",
			function()
				require("neotest").run.run({ suite = true })
			end,
			desc = "Test Suite",
		},
		{
			"<leader>tS",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Test Summary",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Test Output",
		},
		{
			"<leader>tO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Test Output Panel",
		},
		{
			"<leader>tw",
			function()
				local ok, watch = pcall(require, "neotest.watch")
				if ok then
					watch.toggle(vim.fn.expand("%"))
				else
					vim.notify("neotest.watch not available", vim.log.levels.WARN)
				end
			end,
			desc = "Test Watch File",
		},
	},
}

function M.config()
	local neotest = require("neotest")

	neotest.setup({
		quickfix = { enabled = false },
		discovery = { enabled = true },
		status = { virtual_text = true, signs = true },
		summary = { animated = false, follow = true },
		output = { open_on_run = false },
		running = { concurrent = true },
		strategies = { integrated = { width = 120 }, dap = { justMyCode = false } },
		adapters = {
			require("neotest-jest")({
				jestCommand = "npm test --",
				jestConfigFile = function()
					local files = { "jest.config.ts", "jest.config.js", "jest.config.mjs", "jest.config.cjs" }
					for _, f in ipairs(files) do
						if vim.loop.fs_stat(f) then
							return f
						end
					end
					return nil
				end,
				env = { CI = true },
				cwd = function(path)
					return vim.fn.getcwd()
				end,
			}),
			require("neotest-vitest")({
				vitestCommand = function()
					-- Prefer local vitest if available
					if vim.fn.filereadable("node_modules/.bin/vitest") == 1 then
						return "node_modules/.bin/vitest"
					end
					return "vitest"
				end,
				is_test_file = function(file)
					return string.match(file, "%.test%.[jt]sx?$") or string.match(file, "%.spec%.[jt]sx?$")
				end,
			}),
			require("neotest-python")({
				dap = { justMyCode = false },
				args = { "--log-level", "DEBUG" },
				runner = "pytest",
			}),
			require("neotest-dotnet")({
				dap = { justMyCode = false },
				dotnet_adapter = {
					command = "dotnet",
					args = { "test", "--no-build", "--verbosity", "normal" },
				},
			}),
		},
	})
end

return M
