local M = {}

function M.get_plugin()
	return {
		'lervag/vimtex',
		config = function()
			vim.g.tex_flavor = 'latex'
			vim.g.vimtex_view_method='zathura'
		end
	}
end

return M
