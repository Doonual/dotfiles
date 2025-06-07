local M = {}

function M.get_plugin()
	return {
		'feline-nvim/feline.nvim',
		config = function()

			local catppuccin_cols = {
				col_0 = '#585b70',
				col_1 = '#313244',
				tekxt = '#cdd6f4',
				bar_bg = '#1e1e2e',
				mauve = '#cba6f7',
				red = '#f38ba8',
				yellow = '#f9e2af',
				green = '#a6e3a1',
				sky = '#89dceb',
				blue = '#89b4fa',
			}

			local vi_mode_colors = {
				NORMAL = catppuccin_cols.blue,
				OP = catppuccin_cols.blue,
				INSERT = catppuccin_cols.green,
				VISUAL = catppuccin_cols.mauve,
				LINES = catppuccin_cols.mauve,
				BLOCK = catppuccin_cols.red,
				REPLACE = catppuccin_cols.red,
				COMMAND = catppuccin_cols.yellow,
			}

			--          
			local c = {
				
				vim_mode = {
					provider = {
						name = 'vi_mode',
						opts = {
							show_mode_name = true,
							-- padding = "center", -- Uncomment for extra padding.
						},
					},
					hl = function()
						local mode = require('feline.providers.vi_mode').get_vim_mode()
						return {
							bg = vi_mode_colors[mode],
							fg = catppuccin_cols.bar_bg,
							style = 'bold',
							name = 'NeovimModeHLColor',
						}
					end,
					left_sep = {
						str = '█',
						hl = function()
							local mode = require('feline.providers.vi_mode').get_vim_mode()
							return {
								fg = vi_mode_colors[mode],
								bg = catppuccin_cols.col_0, -- bg of the next component
							}
						end,
					},
					right_sep = {
						str = '█',
						hl = function()
							local mode = require('feline.providers.vi_mode').get_vim_mode()
							return {
								fg = vi_mode_colors[mode],
								bg = catppuccin_cols.col_0, -- bg of the next component
							}
						end,
					},
				},
				
				gitBranch = {
					provider = 'git_branch',
					hl = {
						fg = 'peanut',
						bg = catppuccin_cols.col_1,
						style = 'bold',
					},
					left_sep = 'block',
					right_sep = 'block',
				},
				
				gitDiffAdded = {
					provider = 'git_diff_added',
					icon = ' ',
					hl = {
						fg = 'green',
						bg = catppuccin_cols.col_0,
					},
					left_sep = 'block',
					right_sep = 'block',
				},
				gitDiffRemoved = {
					provider = 'git_diff_removed',
					icon = ' ',
					hl = {
						fg = 'red',
						bg = catppuccin_cols.col_0,
					},
					left_sep = 'block',
					right_sep = 'block',
				},
				gitDiffChanged = {
					provider = 'git_diff_changed',
					icon = ' ',
					hl = {
						fg = 'fg',
						bg = catppuccin_cols.col_0,
					},
					left_sep = 'block',
					right_sep = 'right_filled',
				},

				separator = {
					provider = '',
				},

				fileinfo = {
					provider = {
						name = 'file_info',
						opts = {
							type = 'base-only',
						},
					},
					hl = {
						style = 'bold',
						fg = catppuccin_cols.text,
						bg = catppuccin_cols.col_1,
					},
					left_sep = {
						str = '█',
						hl = function()
							return {
								fg = catppuccin_cols.col_1,
								bg = catppuccin_cols.col_1,
							}
						end,
					},
					right_sep = {
						str = '█',
						hl = function()
							return {
								fg = catppuccin_cols.col_1,
								bg = catppuccin_cols.bar_bg,
							}
						end,
					},
				},
				
				current_folder = {
					provider = function()
						-- Get current working directory's name
						return '󰉋 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
					end,
					hl = {
						fg = catppuccin_cols.text,
						bg = catppuccin_cols.col_0,
						style = 'bold',
					},
					left_sep = {
						str = '█',
						hl = function()
							return {
								fg = catppuccin_cols.col_0,
								bg = catppuccin_cols.col_0,
							}
						end,
					},
					right_sep = {
						str = '█',
						hl = function()
							return {
								fg = catppuccin_cols.col_0,
								bg = catppuccin_cols.col_1,
							}
						end,
					},
				},
				
				diagnostic_errors = {
					provider = 'diagnostic_errors',
					hl = {
						bg = catppuccin_cols.bar_bg,
						fg = catppuccin_cols.red,
					},
				},
				diagnostic_warnings = {
					provider = 'diagnostic_warnings',
					hl = {
						bg = catppuccin_cols.bar_bg,
						fg = catppuccin_cols.yellow,
					},
				},
				diagnostic_hints = {
					provider = 'diagnostic_hints',
					hl = {
						bg = catppuccin_cols.bar_bg,
						fg = catppuccin_cols.sky,
					},
				},
				diagnostic_info = {
					provider = 'diagnostic_info',
					hl = {
						bg = catppuccin_cols.bar_bg,
						fg = catppuccin_cols.sky,
					},
				},

				lsp_client_names = {
					provider = 'lsp_client_names',
					hl = {
						fg = 'purple',
						bg = 'darkblue',
						style = 'bold',
					},
					left_sep = 'left_filled',
					right_sep = 'block',
				},

				position = {
					provider = 'position',
					hl = {
						fg = catppuccin_cols.text,
						bg = catppuccin_cols.col_1,
					},
					left_sep = {
						str = '  █',
						hl = function()
							return {
								fg = catppuccin_cols.col_1,
								bg = catppuccin_cols.bar_bg,
							}
						end,
					},
					
					right_sep = 'block',
				},
				
				line_percentage = {
					provider = 'line_percentage',
					hl = {
						fg = catppuccin_cols.text,
						bg = catppuccin_cols.col_1,
					},
					left_sep = 'block',
					right_sep = 'block',
				},
			}

			local components = {
				active = {
					{},
					{},
					{},
				},
				inactive = {
					{},
					{},
					{},
				},
			}

			table.insert(components.active[1], c.vim_mode)
			table.insert(components.active[1], c.current_folder)
			table.insert(components.active[1], c.fileinfo)
			-- table.insert(components.active[3], c.gitBranch)
			-- table.insert(components.active[3], c.gitDiffAdded)
			-- table.insert(components.active[3], c.gitDiffRemoved)
			-- table.insert(components.active[3], c.gitDiffChanged)

			table.insert(components.active[3], c.diagnostic_errors)
			table.insert(components.active[3], c.diagnostic_warnings)
			table.insert(components.active[3], c.diagnostic_info)
			table.insert(components.active[3], c.diagnostic_hints)
			-- table.insert(components.active[3], c.lsp_client_names)
			table.insert(components.active[3], c.position)
			table.insert(components.active[3], c.line_percentage)

			require('feline').setup { components = components }
		end
	}
end

return M
