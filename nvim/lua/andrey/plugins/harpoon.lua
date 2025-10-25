return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		local keymap = function(keys, func)
			vim.keymap.set("n", keys, func)
		end

		local list_select_keymap = function(index)
			keymap("<leader>" .. tostring(index), function()
				harpoon:list():select(index)
			end)
		end

		keymap("<leader>ha", function()
			harpoon:list():add()
		end)
		keymap("<leader>hm", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		for i = 1, 9 do
			list_select_keymap(i)
		end

		keymap("<leader>bp", function()
			harpoon:list():prev()
		end)
		keymap("<leader>bn", function()
			harpoon:list():next()
		end)
	end,
}
