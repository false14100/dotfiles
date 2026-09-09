local M = { "Vigemus/iron.nvim" }

function M.config()
	local iron = require("iron.core")
	local view = require("iron.view")
	local common = require("iron.fts.common")

	iron.setup({
		config = {
			-- Whether a repl should be discarded or not
			scratch_repl = true,
			-- Your repl definitions come here
			repl_definition = {
				sh = {
					-- Can be a table or a function that
					-- returns a table (see below)
					command = { "zsh" },
				},
				python = {
					command = { "ipython" }, -- or { "ipython", "--no-autoindent" }
					format = common.bracketed_paste_python,
					block_dividers = { "# %%", "#%%" },
					env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
				},
				sml = {
					command = { "sml" },
					format = function(lines)
						-- Keywords that start new declarations in SML
						local decl_keywords = {
							"val",
							"fun",
							"datatype",
							"type",
							"exception",
							"structure",
							"signature",
							"functor",
							"local",
							"open",
							"infix",
							"infixr",
							"nonfix",
						}

						local result = {}
						local current_decl = {}

						for _, line in ipairs(lines) do
							local trimmed = line:gsub("^%s+", "")
							local is_new_decl = false

							-- Check if line starts with a declaration keyword
							for _, kw in ipairs(decl_keywords) do
								if trimmed:match("^" .. kw .. "%s") or trimmed:match("^" .. kw .. "$") then
									is_new_decl = true
									break
								end
							end

							-- If new declaration and we have a previous one, add semicolon to it
							if is_new_decl and #current_decl > 0 then
								local decl = table.concat(current_decl, "\n")
								if not decl:match(";%s*$") then
									decl = decl .. ";"
								end
								table.insert(result, decl)
								current_decl = {}
							end

							table.insert(current_decl, line)
						end

						-- Handle the last declaration
						if #current_decl > 0 then
							local decl = table.concat(current_decl, "\n")
							if not decl:match(";%s*$") then
								decl = decl .. ";"
							end
							table.insert(result, decl)
						end

						return table.concat(result, "\n") .. "\n"
					end,
				},
				ocaml = {
					command = { "utop" },
				},
			},
			-- set the file type of the newly created repl to ft
			-- bufnr is the buffer id of the REPL and ft is the filetype of the
			-- language being used for the REPL.
			repl_filetype = function(bufnr, ft)
				return ft
				-- or return a string name such as the following
				-- return "iron"
			end,
			-- Send selections to the DAP repl if an nvim-dap session is running.
			dap_integration = true,
			repl_open_cmd = view.split.vertical.rightbelow("40%"),
		},
		-- Iron doesn't set keymaps by default anymore.
		-- You can set them here or manually add keymaps to the functions in iron.core
		keymaps = {
			toggle_repl = "<space>rt",
			restart_repl = "<space>rR",
			visual_send = "<space>vs",
			send_line = "<space>rl",
			send_file = "<space>rf",
			cr = "<space>s<cr>",
			interrupt = "<space>s<space>",
			clear = "<space>rc",
		},

		-- If the highlight is on, you can change how it looks
		-- For the available options, check nvim_set_hl
		highlight = {
			italic = true,
		},
		ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
	})
end

return M
