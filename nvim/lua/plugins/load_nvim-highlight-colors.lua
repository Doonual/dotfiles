local M = {}

function M.get_plugin()
	return {
		'brenoprata10/nvim-highlight-colors',
		config = function()
			require('nvim-highlight-colors').setup({})
		end
	}
end

return M
