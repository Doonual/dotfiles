local M = {}

function M.get_plugin()
	return {
		'OmniSharp/omnisharp-vim',
		config = function()
			vim.g.OmniSharp_server_use_net6 = 1
		end
	}
end

return M
