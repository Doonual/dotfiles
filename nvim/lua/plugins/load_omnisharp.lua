local M = {}

function M.get_plugin()
	return {
		'OmniSharp/omnisharp-vim',
		config = function()
			vim.Omnisharp_server_stdio = 1
			--vim.using_snippets = 0
		end
	}
end

return M
