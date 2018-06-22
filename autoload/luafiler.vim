lua <<LUA
	require("luafiler")
LUA

augroup LuaFiler
autocmd!
autocmd FileType *
	\ if isdirectory(@%)
	\|   call luaeval("plugin.filer.render_dirs()")
	\|   nnoremap <silent> WO :call<Space>luaeval('plugin.filer.open()')<CR>
	\|   nnoremap <silent> WV :call<Space>luaeval('plugin.filer.open("v")')<CR>
	\| endif
augroup END

