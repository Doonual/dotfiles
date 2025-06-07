local M = {}

function M.get_plugin()
	return {
		'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } 
	}
end

return M
