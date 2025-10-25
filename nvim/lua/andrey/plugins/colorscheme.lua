return {
	{
		"rebelot/kanagawa.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("kanagawa").setup({
				colors = {
					theme = {
						wave = {
							syn = {
								constant = "none",
							},
						},
					},
				},
			})
			vim.cmd([[colorscheme kanagawa]])
		end,
	},
}
