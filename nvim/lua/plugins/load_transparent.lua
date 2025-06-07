local M = {}

function M.get_plugin()
	return {
		'xiyaowong/transparent.nvim',
		config = function()
			require("transparent").setup({
				
				groups = {
					"Normal"
				},
				
			})
		end

	}
end

return M
