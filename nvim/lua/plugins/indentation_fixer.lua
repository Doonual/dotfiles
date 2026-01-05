local M = {}

function M.load()
	
	local activate_plugin = function()
		
		if vim.bo.modifiable == false or vim.bo.readonly == true then
			return false
		end

		-- If the user has a redo, don't do anything
		if (vim.fn.undotree().seq_cur < vim.fn.undotree().seq_last) then
			return false
		end

		return true

	end
	
	local set_line_text = function(line_number, text)
		vim.api.nvim_buf_set_lines(0,line_number - 1,line_number, false, {text})
	end
	local delete_line = function(line_number, text)
		vim.api.nvim_buf_set_lines(0,line_number - 1, line_number, false, {})
	end
	local get_line_text = function(line_number)
		return vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
	end
	
	local count_char = function(string, char)
		local chars_found = 0
		for i=1,#string do
			local current_char = string:sub(i,i)
			if current_char == char then
				chars_found = chars_found + 1
			end
		end
		return chars_found
	end
	
	local strip_starting_tabs = function(text)
		local out = text
		while (out:sub(1,1) == "	") do
			out = out:sub(2)
		end
		
		return out

	end

	local strip_starting_spaces = function(text)
		local out = text
		while (out:sub(1,1) == " ") do
			out = out:sub(2)
		end
		
		return out

	end

	local get_indent = function(line_num)
		
		local current_indent = 0
		
		for i=1,line_num - 1 do
			current_indent = current_indent + count_char(get_line_text(i), '{')
		end
		for i=1,line_num - 1 do
			current_indent = current_indent - count_char(get_line_text(i), '}')
		end

		local line_text = get_line_text(line_num)
		local current_line = "" .. line_text
		current_line = strip_starting_tabs(current_line)
		current_line = strip_starting_spaces(current_line)
		if current_line:sub(1,1) == '}' then
			current_indent = current_indent - 1
		end


		return current_indent

	end


	vim.opt.virtualedit:append("onemore")
	local fix_indent = function(line_num)
		
		local expected_indent = get_indent(line_num)
		local current_indent = vim.fn.indent(line_num) / 4
		local indent_delta = current_indent - expected_indent
		if indent_delta < 0 then
			-- Add tabs at start
			for i=0,-indent_delta - 1 do
				set_line_text(line_num, "	" .. get_line_text(line_num))
			end
		end
		
		if indent_delta > 0 then
			-- remove tabs at start
			for i=0, indent_delta - 1 do
				set_line_text(line_num, get_line_text(line_num):sub(2))
			end
		end

	end

	local move_to_highest_indent = function()
		cursor_line = vim.fn.line('.')
		cursor_x = vim.api.nvim_win_get_cursor(0)[2]
		local indent_level = vim.fn.indent(cursor_line) / 4
		local new_x = math.max(indent_level, cursor_x)
		vim.api.nvim_win_set_cursor(0, {cursor_line, math.floor(new_x)})
		return new_x
	end

	fix_indent_recursively = function(line_num)

		local total_lines = vim.api.nvim_buf_line_count(0)
		for i=line_num,total_lines,1 do
			if (get_indent(i) ~= vim.fn.indent(i) / 4) then
				fix_indent(i)
			else
				break
			end
		end
		
		for i=line_num - 1,1,-1 do
			if i >= 1 then
				if (get_indent(i) ~= vim.fn.indent(i) / 4) then
					fix_indent(i)
				else
					break
				end
			end
		end

	end

	

	local cursor_line = 0
	local cursor_x = 0

	local cursor_line_previous = 1
	local cursor_x_previous = 0

	local dont_update_cursor_moved = false
	
	local cursor_moved_func = function()
		
		if activate_plugin() == true then
			

			cursor_line = vim.fn.line('.')
			cursor_x = vim.api.nvim_win_get_cursor(0)[2]
			


			--if (cursor_line ~= cursor_line_previous or true) then
			fix_indent_recursively(cursor_line)
			cursor_x = move_to_highest_indent()
			--end

			cursor_line_previous = cursor_line
			cursor_x_previous = cursor_x

		end

	end

	local text_changed_func = function()
		if activate_plugin() == true then
			if (vim.fn.line('.') ~= 1) then
				fix_indent_recursively(vim.fn.line('.') - 1)
			end
			if (vim.fn.line('.') ~= vim.api.nvim_buf_line_count(0)) then
				fix_indent_recursively(vim.fn.line('.') + 1)
			end

		end

	end
	
	local total_lines_previous = 0
	local fix_if_line_deleted = function()
		
		local total_lines = vim.api.nvim_buf_line_count(0)
		local cursor_line = vim.fn.line('.')
		local cursor_x = vim.api.nvim_win_get_cursor(0)[2]
		
		if (total_lines < total_lines_previous) then
			

			local text_after_cursor = get_line_text(cursor_line):sub(cursor_x + 1)
			local text_before_cursor = get_line_text(cursor_line):sub(1,cursor_x)
			text_after_cursor = strip_starting_tabs(text_after_cursor)
			set_line_text(cursor_line, text_before_cursor .. text_after_cursor)


		end

		if (total_lines ~= total_lines_previous) then
			if cursor_line + 1 <= vim.api.nvim_buf_line_count(0) then
				fix_indent_recursively(cursor_line + 1)
			end
			if cursor_line - 1 >= 0 then
				fix_indent_recursively(cursor_line - 1)
			end
		end

		total_lines_previous = total_lines

	end

	vim.api.nvim_create_autocmd("CursorMoved", {
		pattern = "*",
		callback = function()
			cursor_moved_func()

		end

	})
	
	vim.api.nvim_create_autocmd("CursorMovedI", {
		pattern = "*",
		callback = function()
			cursor_moved_func()
		end
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		
		
		pattern = "*",
		callback = function()
			--fix_if_line_deleted()
			cursor_moved_func()
		end

	})



	vim.api.nvim_create_autocmd("TextChanged", {
		pattern = "*",
		callback = function()
			
			if activate_plugin() == true then
				cursor_moved_func()
				fix_if_line_deleted()
				text_changed_func()
			end
		end
	})
	vim.api.nvim_create_autocmd("TextChangedI", {
		pattern = "*",
		callback = function()
			
			if activate_plugin() == true then
				cursor_moved_func()
				fix_if_line_deleted()
				text_changed_func()
			end

		end
	})
	
	vim.api.nvim_create_user_command("FixIndent", function(opts)

		local total_lines = vim.api.nvim_buf_line_count(0)
		for i=1,total_lines do
			local line_text = get_line_text(i);
			line_text = strip_starting_spaces(line_text);
			set_line_text(i, line_text);

		end

		for i=1,total_lines do

			fix_indent(i)

		end
	end, { nargs = 0 })
	
end


return M
