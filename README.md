luafiler
===

simple filer for Neovim

```
====================================
/home/nymphium/.vim/bundle/luafiler/
====================================

./
../
.git/
LICENSE
autoload/
lua/
plugin/
README.md
```

# module API
The module is located `plugin.luafiler`.

## `luafiler.render_dirs([path])`
Render `path` or current directory by default on the current buffer

## `luafiler.open(["v" | "h"])`
Open file by reading filename under the cursor.
You can select the opening mode 'v'ertically or 'h'orizontally. By default the mode is set to 'h'.

# config example
Open directory with luafiler automatically, you can use automd like this:

```vim
augroup LuaFiler
  autocmd!
  autocmd FileType *
    \ if isdirectory(@%)
    \|   call luaeval("plugin.luafiler.render_dirs()")
    \|   nnoremap <silent> WO :call<Space>luaeval('plugin.luafiler.open()')<CR>
    \|   nnoremap <silent> WV :call<Space>luaeval('plugin.luafiler.open("v")')<CR>
    \| endif
augroup END
```

# LICENSE
MIT
