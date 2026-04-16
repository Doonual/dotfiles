--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========									.-----.			 ========
========		 .----------------------.	| === |			 ========
========		 |.-""""""""""""""""""-.|	|-----|			 ========
========		 ||					   ||	| === |			 ========
========		 ||   KICKSTART.NVIM   ||	|-----|			 ========
========		 ||					   ||	| === |			 ========
========		 ||					   ||	|-----|			 ========
========		 ||:Tutor			   ||	|:::::|			 ========
========		 |'-..................-'|	|____o|			 ========
========		 `"")----------------(""`	___________		 ========
========		/::::::::::|  |::::::::::\	\ no mouse \	 ========
========	   /:::========|  |==hjkl==:::\  \ required \	 ========
========	  '""""""""""""'  '""""""""""""'  '""""""""""'	 ========
========													 ========
=====================================================================
=====================================================================

--]]

--[[
#################################
########## Indentation ##########
#################################
--]]

-- Fuck vim's shit default indentation off forever
-- Replace it with my own correct indentation
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  callback = function()
    vim.opt_local.autoindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.cindent = false
    vim.opt_local.indentexpr = ""
  end,
})



vim.deprecate = function()
	-- Dodgy
end

vim.opt.modeline = false
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt.breakindent = true


vim.api.nvim_create_autocmd('FileType', {
	pattern = {"c","cpp", "cs", "java", "rs", "rust"},
	callback = function()
		local indent_expr = {"{$", "%[$", "%($"}
		local outdent_expr = {"^/*}", "^/*%]", "^/*%)"}
		require("plugins/indentation_fixer").load(indent_expr, outdent_expr)
	end,
})

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
--  NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
-- Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)


-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- See `:help 'list'`
-- and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
--vim.opt.confirm = true

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows
--
-- See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
	vim.highlight.on_yank()
	end,
})

-- ###########################
-- ### Lazy Plugin Manager ###
-- ###########################

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
local plugins = {

	require("plugins/load_gitsigns").get_plugin(),
	require("plugins/load_which-key").get_plugin(),
	require("plugins/load_telescope").get_plugin(),
	
	-- Colour themes
	--require("plugins/load_tokyonight").get_plugin(),
	require("plugins/load_catppuccin").get_plugin(),
	require("plugins/load_transparent").get_plugin(),
	require("plugins/load_nvim-highlight-colors").get_plugin(),
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require('nvim-highlight-colors').setup({})
		end
	},
	
	-- Status bar
	require("plugins/load_feline").get_plugin(),
	
	-- Highlight, edit, and navigate code
	require("plugins/load_nvim-treesitter").get_plugin(),
	{
		"m4xshen/autoclose.nvim",
		config = function()
			require('autoclose').setup({
				[";"] = { escape = false, close = false}
			})
		end
	},

	-- ###########
	-- ### LSP ###
	-- ###########
	{
		"prabirshrestha/vim-lsp",
		config = function()
			vim.cmd([[

			if executable('ccls')
				au User lsp_setup call lsp#register_server({
					\ 'name': 'ccls',
					\ 'cmd': {server_info->['ccls']},
					\ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
					\ 'initialization_options': {},
					\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
				\ })
			endif

			]])
		end
	},
	{
		"neovim/nvim-lspconfig",
		config = function()

			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			local lspconfig = require('lspconfig')

			lspconfig.ccls.setup({
			  capabilities = capabilities,
			})


		end
	},
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		-- Completiom framework
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require'cmp'
			cmp.setup({
			-- Enable LSP snippets
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body)
				end,
			},
			mapping = {
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-n>'] = cmp.mapping.select_next_item(),
				-- Add tab support
				['<S-Tab>'] = cmp.mapping.select_prev_item(),
				['<Tab>'] = cmp.mapping.select_next_item(),
				['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.close(),
				['<CR>'] = cmp.mapping.confirm({
				  behavior = cmp.ConfirmBehavior.Insert,
				  select = true,
				})
			},
			-- Installed sources:
			sources = {
				{ name = 'path' },                              -- file paths
				{ name = 'nvim_lsp', keyword_length = 1 },      -- from language server
				{ name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
				{ name = 'nvim_lua', keyword_length = 1},       -- complete neovim's Lua runtime API such vim.lsp.*
				{ name = 'buffer', keyword_length = 1 },        -- source current buffer
				{ name = 'vsnip', keyword_length = 1 },         -- nvim-cmp source for vim-vsnip 
				{ name = 'calc'},                               -- source for math calculation
			  },
			  window = {
				  completion = cmp.config.window.bordered(),
				  documentation = cmp.config.window.bordered(),
			  },
			  formatting = {
				  fields = {'menu', 'abbr', 'kind'},
				  format = function(entry, item)
					  local menu_icon ={
						  nvim_lsp = 'λ',
						  vsnip = '⋗',
						  buffer = 'Ω',
						  path = '🖫',
					  }
					  item.menu = menu_icon[entry.source.name]
					  return item
				  end,
			  },
			})
		end
	},
	{
		-- LSP completion source
		"hrsh7th/cmp-nvim-lsp"
	},
	{
		-- Useful completion source
		"hrsh7th/cmp-nvim-lua"
	},
	{
		-- Useful completion source
		"hrsh7th/cmp-nvim-lsp-signature-help"
	},
	{
		-- Useful completion source
		"hrsh7th/cmp-vsnip"
	},
	{
		-- Useful completion source
		"hrsh7th/cmp-path"
	},
	{
		-- Useful completion source
		"hrsh7th/cmp-buffer"
	},
	{
		-- Useful completion source
		"hrsh7th/vim-vsnip"
	},
	

	{
		"simrat39/rust-tools.nvim",
		config = function()
			local rt = require("rust-tools")
			rt.setup({
				server = {
					on_attach = function(_, bufnr)
					  -- Hover actions
					  vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
					  -- Code action groups
					  vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
				},
			})
		end
	},


}



require('lazy').setup(plugins, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = '⌘',
			config = '🛠',
			event = '📅',
			ft = '📂',
			init = '⚙',
			keys = '🗝',
			plugin = '🔌',
			runtime = '💻',
			require = '🌙',
			source = '📄',
			start = '🚀',
			task = '📌',
			lazy = '💤 ',
		},
	},
})


--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
	set signcolumn=yes
	autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])


--require('lspconfig').pylsp.setup {
--	settings = {
--	  pylsp = {
--		plugins = {
--		  pycodestyle = { enabled = false }, -- Disable pycodestyle linter
--		},
--	  },
--	},
--}



-- The line beneath this is called `modeline`. See `:help modeline`




