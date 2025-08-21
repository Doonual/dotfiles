local M = {}

function M.load()


	local set_line_text = function(line_number, text)
		vim.api.nvim_buf_set_lines(0,line_number - 1,line_number, false, {text})
	end
	local delete_line = function(line_number, text)
		vim.api.nvim_buf_set_lines(0,line_number - 1, line_number, false, {})
	end
	local get_line_text = function(line_number)
		return vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
	end

	vim.opt.virtualedit:append("onemore")
	local fix_indent = function(line_num)
		
		local expected_indent = vim.fn.cindent(line_num) / 4
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
		vim.api.nvim_win_set_cursor(0, {cursor_line, new_x})
		return new_x
	end

	fix_indent_recursively = function(line_num)

		local total_lines = vim.api.nvim_buf_line_count(0)
		for i=line_num,total_lines,1 do
			if (vim.fn.cindent(i) ~=vim.fn.indent(i)) then
				fix_indent(i)
			else
				break
			end
		end
		
		for i=line_num,0,-1 do
			if (vim.fn.cindent(i) ~=vim.fn.indent(i)) then
				fix_indent(i)
			else
				break
			end
		end

	end

	local strip_starting_tabs = function(text)
		local out = text
		while (out:sub(1,1) == "	") do
			out = out:sub(2)
		end
		
		return out

	end

	local cursor_line = 0
	local cursor_x = 0

	local cursor_line_previous = 1
	local cursor_x_previous = 0

	local dont_update_cursor_moved = false

	vim.api.nvim_create_autocmd("CursorMoved", {
		pattern = "*",
		callback = function()

			cursor_line = vim.fn.line('.')
			cursor_x = vim.api.nvim_win_get_cursor(0)[2]
			local moved_line = cursor_line ~= cursor_line_previous
			
			if (moved_line == true) then
				fix_indent_recursively(cursor_line)

				if (cursor_x_previous == (vim.fn.indent(cursor_line_previous) / 4)) then
					vim.api.nvim_win_set_cursor(0, {cursor_line, vim.fn.indent(cursor_line) / 4})
				end

				cursor_x = move_to_highest_indent()
				local previous_line_x = cursor_x_previous - (vim.fn.indent(cursor_line_previous) / 4)
				
				local new_line_x = previous_line_x + (vim.fn.indent(cursor_line) / 4)
				new_line_x = math.max(0, new_line_x, string.len(get_line_text(cursor_line)))
				--print(new_Line_x)
				--vim.api.nvim_win_set_cursor(0, {cursor_line, new_line_x})
			end

			cursor_line_previous = cursor_line
			cursor_x_previous = cursor_x

		end

	})
	
	vim.api.nvim_create_autocmd("CursorMovedI", {
		pattern = "*",
		callback = function()

			cursor_line = vim.fn.line('.')
			cursor_x = vim.api.nvim_win_get_cursor(0)[2]
			local indentation_level = vim.fn.cindent(cursor_line) / 4


			if (cancel == false and cursor_x < indentation_level) then
				
				local line_text = get_line_text(cursor_line)
				local line_text_before_cursor = strip_starting_tabs(line_text:sub(0,cursor_x))
				if (string.len(line_text_before_cursor) == 0) then
					
					local new_cursor_line = cursor_line - 1
					local new_cursor_x = string.len(get_line_text(cursor_line - 1))
					local moved_string = strip_starting_tabs(line_text)
					
					cursor_line_previous = cursor_line
					cursor_line = new_cursor_line
					cursor_x = new_cursor_x
					
					set_line_text(cursor_line, get_line_text(cursor_line) .. line_text)
					vim.api.nvim_win_set_cursor(0, {new_cursor_line, new_cursor_x})
					delete_line(cursor_line + 1)

				end


				
			end

			cursor_line_previous = cursor_line
			cursor_x_previous = cursor_x

		end
	})

	vim.api.nvim_create_autocmd("InsertLeave", {

		pattern = "*",
		callback = function()
			fix_indent_recursively(vim.fn.line('.'))
			move_to_highest_indent()
		end

	})

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
			fix_indent_recursively(cursor_line + 1)
			fix_indent_recursively(cursor_line - 1)
		end

		total_lines_previous = total_lines

	end


	vim.api.nvim_create_autocmd("TextChanged", {
		pattern = "*",
		callback = function()

			fix_if_line_deleted()
			
			local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
			fix_indent_recursively(cursor_line - 1)
			fix_indent_recursively(cursor_line)
			fix_indent_recursively(cursor_line + 1)

		end
	})
	vim.api.nvim_create_autocmd("TextChangedI", {
		pattern = "*",
		callback = function()
		
			fix_if_line_deleted()
			

			local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
			fix_indent_recursively(cursor_line - 1)
			fix_indent_recursively(cursor_line)
			fix_indent_recursively(cursor_line + 1)
			

		end
	})
	
	vim.api.nvim_create_autocmd("InsertCharPre", {

		pattern = "*",
		callback = function()

			print("char is: " .. vim.v.char)


		end


	})
	
	
end


return M
