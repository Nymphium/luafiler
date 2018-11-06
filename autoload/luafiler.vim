function! luafiler#load()
	lua <<LUA
local api = vim.api
local verror = api.nvim_err_writeln

local do_not_warn_on_start

pcall(function()
	do_not_warn_on_start = api.nvim_get_var("luafiler_do_not_warn_on_start") > 0
end)

local handle = function(msg)
	if not do_not_warn_on_start then
		api.nvim_err_writeln(msg)
	end
end

xpcall(require, handle, "luafiler")
LUA
endfunction

augroup LuaFiler
	autocmd!
	autocmd VimEnter,BufNew *
		\ if isdirectory(@%)
		\|   call luaeval("plugin.luafiler.render_dirs([[" . @% . "]])")
		\| endif
	autocmd QuitPre * call luaeval('plugin.luafiler.delete()')
augroup END

