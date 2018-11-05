plugin = plugin or {}

if plugin.luafiler then
	return
end

local api = vim.api
local verror = api.nvim_err_writeln

local ok, lfs = pcall(function()
	return require('lfs')
end)

if not ok then
	return error("lfs is not found; install `luafilesystem' module")
end

local bufs = {}
local luafiler = {
	bufs = bufs
}

plugin.luafiler = luafiler

local function generate_header(path)
	local eqs = ('='):rep(#path)
	return {eqs, path, eqs, ''}
end

local header_length = 5

function luafiler.render_dirs(path)
	local current_buf = api.nvim_get_current_buf()
	local replace_tbl = {}
	local file_attrs = {}

	if path then
		if not path:match('/$') then
			path = path .. '/'
		end

		-- normalize path name
		while path and path:match('%.%./$') do
			path = path:match('^(.*/)[^/]+/%.%./$')
		end

		while path and path:match('%./$') do
			path = path:match('^(.*/)%./$')
		end
	end

	path = path or lfs.currentdir() .. "/"

	for file in lfs.dir(path) do
		local name = file
		local attr = lfs.attributes(path .. file)

		if attr.mode == 'directory' then
			name = name .. '/'
		end

		table.insert(replace_tbl, name)
		table.insert(file_attrs, attr)
	end

	local merged_tbl = {}
	for i = 1, #replace_tbl do
		merged_tbl[i] = {
			name = replace_tbl[i],
			attr = file_attrs[i]
		}
	end

	table.sort(merged_tbl, function(a, b)
		return a.name:upper() < b.name:upper()
	end)

	table.sort(merged_tbl, function(a, b)
		return a.attr.mode < b.attr.mode
	end)

	bufs[current_buf] = {root = path}
	local now_buf = bufs[current_buf]

	local names = {}
	for i = 1, #merged_tbl do
		names[i] = merged_tbl[i].name
		now_buf[i] = merged_tbl[i]
	end

	local header = generate_header(path)
	api.nvim_buf_set_lines(current_buf, 0, header_length - 1, nil, header)
	api.nvim_buf_set_lines(current_buf, header_length - 1, -1, nil, names)
	api.nvim_buf_set_option(current_buf, 'modifiable', false)
end

-- open file with vertical or horizontal
local opening_mode =
	setmetatable({
			  v = 'vnew ',
			  h = 'new '
		  }, {
			  __index = function(_, k)
				  if not k then
					  -- default horizontal
					  return 'new '
				  end

				  return verror(("invalid mode `%s'"):format(k))
			  end})

function luafiler.open(mode)
	local current_line = api.nvim_win_get_cursor(api.nvim_get_current_win())[1] - header_length + 1

	if current_line < 0 then
		return verror('no file specified to open')
	end

	local current_buf = api.nvim_get_current_buf()
	local buf_conts = bufs[current_buf]

	if not buf_conts then
		return verror("not in a luafiler buffer")
	end

	local cont = buf_conts[current_line]

	if cont.attr.mode == 'directory' then
		api.nvim_buf_set_option(current_buf, 'modifiable', true)
		luafiler.render_dirs(buf_conts.root .. cont.name)
		api.nvim_buf_set_option(current_buf, 'modifiable', false)
	else
		api.nvim_command(opening_mode[mode] .. buf_conts.root .. cont.name)

		local list_win = api.nvim_list_wins()
		table.sort(list_win)
		api.nvim_set_current_win(list_win[#list_win])
	end
end

