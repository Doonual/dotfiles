local M = {}

function M.get_plugin()
	return {
		'catppuccin/nvim',
		name = 'catppuccin',
		flavour = 'mocha',
		priority = 1000,
		config = function()
			require('catppuccin').load 'mocha'
		end
	}
end

return M
