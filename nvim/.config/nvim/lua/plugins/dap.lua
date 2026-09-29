local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- "leoluz/nvim-dap-go",
		-- "mfussenegger/nvim-dap-python",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"Jorenar/nvim-dap-disasm",
		"nvim-neotest/nvim-nio",
		"mxsdev/nvim-dap-vscode-js",
		"jay-babu/mason-nvim-dap.nvim",
	},
}

function M.config()
	local dap = require("dap")
	local dapui = require("dapui")

	dapui.setup({
		controls = {
			enabled = true,
			element = "repl",
		},
		layouts = {
			{
				-- Left sidebar: scopes + watches + breakpoints stacked
				position = "left",
				size = 40,
				elements = {
					{ id = "scopes", size = 0.5 },
					{ id = "watches", size = 0.25 },
					{ id = "breakpoints", size = 0.25 },
				},
			},
			{
				-- Bottom tray: REPL + console side by side
				position = "bottom",
				size = 12,
				elements = {
					{ id = "repl", size = 0.5 },
					{ id = "console", size = 0.5 },
				},
			},
			{
				elements = { { id = "disassembly" } },
				position = "bottom",
				size = 0.15,
			},
		},
		floating = {
			max_height = 0.9,
			max_width = 0.9,
			border = "rounded",
			mappings = { close = { "q", "<Esc>" } },
		},
		render = {
			max_type_length = nil,
			max_value_lines = 100,
		},
	})

	-- Auto-open/close UI with session lifecycle
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	require("dap-disasm").setup({
		dapui_register = true,

		-- Add custom REPL commands for stepping with instruction granularity
		repl_commands = true,

		-- Show winbar with buttons to step into the code with instruction granularity
		-- This settings is overriden (disabled) if the dapview integration is enabled and the plugin is installed
		winbar = true,

		-- The sign to use for instruction the exectution is stopped at
		sign = "DapStopped",

		-- Number of instructions to show before the memory reference
		ins_before_memref = 16,

		-- Number of instructions to show after the memory reference
		ins_after_memref = 16,

		-- Labels of buttons in winbar
		controls = {
			step_into = "Step Into",
			step_over = "Step Over",
			step_back = "Step Back",
		},

		-- Columns to display in the disassembly view
		columns = {
			"address",
			"instructionBytes",
			"instruction",
		},
	})

	require("nvim-dap-virtual-text").setup({})
	-- require("dap-go").setup({})

	-- Python debugging
	dap.adapters.python = {
		type = "executable",
		command = "python",
		args = { "-m", "debugpy.adapter" },
	}

	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			pythonPath = function()
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
		{
			type = "python",
			request = "attach",
			name = "Attach",
			connect = {
				port = 5678,
				host = "127.0.0.1",
			},
		},
		{
			type = "python",
			request = "launch",
			name = "Python: Current File (External Terminal)",
			program = "${file}",
			console = "externalTerminal",
		},
	}

	-- .NET/C# debugging
	dap.adapters.coreclr = {
		type = "executable",
		command = "netcoredbg",
		args = { "--interpreter=vscode" },
	}

	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "Launch .NET Core",
			request = "launch",
			program = function()
				return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
			end,
		},
		{
			type = "coreclr",
			name = "Attach to .NET Core",
			request = "attach",
			processId = function()
				return vim.fn.input("Process ID: ")
			end,
		},
	}

	-- Scala
	dap.configurations.scala = {
		{
			type = "scala",
			request = "launch",
			name = "RunOrTest",
			metals = {
				runType = "runOrTestFile",
			},
		},
		{
			type = "scala",
			request = "launch",
			name = "Test Target",
			metals = {
				runType = "testTarget",
			},
		},
	}

	-- GDB for C/C++/Rust - Optimized for low-level debugging
	dap.adapters.gdb = {
		type = "executable",
		command = "gdb",
		args = {
			"--interpreter=dap",
			"--eval-command",
			"set print pretty on",
			"--eval-command",
			"set disassemble-next-line on",
			"--eval-command",
			"set disassembly-flavor intel",
		},
	}

	dap.configurations.c = {
		{
			name = "Launch",
			type = "gdb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = {}, -- provide arguments if needed
			cwd = "${workspaceFolder}",
			stopAtBeginningOfMainSubprogram = false,
		},
		{
			name = "Select and attach to process",
			type = "gdb",
			request = "attach",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			pid = function()
				local name = vim.fn.input("Executable name (filter): ")
				return require("dap.utils").pick_process({ filter = name })
			end,
			cwd = "${workspaceFolder}",
		},
		{
			name = "Attach to gdbserver :1234",
			type = "gdb",
			request = "attach",
			target = "localhost:1234",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
		},
	}

	dap.configurations.cpp = dap.configurations.c

	-- Rust with GDB
	dap.adapters["rust-gdb"] = {
		type = "executable",
		command = "rust-gdb",
		args = {
			"--interpreter=dap",
			"--eval-command",
			"set print pretty on",
			"--eval-command",
			"set disassemble-next-line on",
			"--eval-command",
			"set disassembly-flavor intel",
		},
	}

	dap.configurations.rust = {
		{
			name = "Launch (Low-Level)",
			type = "rust-gdb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = {},
			cwd = "${workspaceFolder}",
			stopAtBeginningOfMainSubprogram = false,
		},
		{
			name = "Launch (Debug + Symbols)",
			type = "rust-gdb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = {},
			cwd = "${workspaceFolder}",
			stopAtBeginningOfMainSubprogram = true,
		},
		{
			name = "Select and attach to process",
			type = "rust-gdb",
			request = "attach",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			pid = function()
				local name = vim.fn.input("Executable name (filter): ")
				return require("dap.utils").pick_process({ filter = name })
			end,
			cwd = "${workspaceFolder}",
		},
		{
			name = "Attach to gdbserver :1234",
			type = "rust-gdb",
			request = "attach",
			target = "localhost:1234",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
		},
	}

	-- DAP Keymaps for debugging
	local keymap = vim.keymap.set
	keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
	keymap("n", "<leader>dB", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "Set conditional breakpoint" })
	keymap("n", "<leader>dS", dap.continue, { desc = "Continue/Start debugging" })
	keymap("n", "<F3>", dap.step_into, { desc = "Step into" })
	keymap("n", "<F1>", dap.step_over, { desc = "Step over" })
	keymap("n", "<F4>", dap.step_out, { desc = "Step out" })
	keymap("n", "<F2>", dap.step_back, { desc = "Step back" })
	keymap("n", "<F5>", dap.restart, { desc = "Restart debugging" })
	keymap("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
	keymap("n", "<leader>dl", dap.run_last, { desc = "Run last config" })
	keymap("n", "<leader>dt", dap.terminate, { desc = "Terminate debugging" })
	keymap("n", "<leader>dC", dap.clear_breakpoints, { desc = "Clear all breakpoints" })
	keymap("n", "<leader>dT", dapui.close, { desc = "Close dap UI" })
end

return M
