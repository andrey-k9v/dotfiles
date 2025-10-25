return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		require("nvim-ts-autotag").setup()
		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			auto_install = true,
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
		})
	end,
}
