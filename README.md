# Neovim

## C++ LSP

To get c++ code suggestions the following plugins are required
- prabirshrestha/asyncomplete.vim
- prabirshrestha/asyncomplete-lsp.vim
- prabirshrestha/vim-lsp
vim-lsp requires some setup to work, the code I use is this

```
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
```
