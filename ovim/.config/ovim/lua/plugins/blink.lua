local M = {
	"saghen/blink.cmp",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
	},
	version = "1.*",
	opts = {
		keymap = { preset = "default" },

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				window = {
					border = "rounded",
					scrollbar = true,
				},
			},

			menu = {
				border = "rounded",
				scrollbar = true,

				draw = {
					padding = 1,
					gap = 1,

					components = {
						kind_icon = {
							text = function(ctx)
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},

			ghost_text = {
				enabled = false,
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },

		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},
	},

	opts_extend = { "sources.default" },
}

return M
