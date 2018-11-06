luafiler
===

simple filer for Neovim

```
=====================================
/home/nymphium/works/github/luafiler/
=====================================

../
.git/
autoload/
lua/
plugin/
LICENSE
README.md
```

# installation
`NeoBundle Nymphium/luafiler` or something you like

# requirements
install `luafilesystem` and add code to load lua modules at start

```shell-session
$ luarocks --local install luafilesystem
$ cat <<EOL >> ~/.vimrc
lua <<LUA
  local version = _VERSION:match("%d+%.%d+")
  package.path = package.path:gsub("/%d+%.%d+/", ("/%s/"):format(version))
  package.cpath = package.cpath:gsub("/%d+%.%d+/", ("/%s/"):format(version))
LUA
EOL
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
augroup LuafilerSettings
  autocmd!
  autocmd FileType * nnoremap <silent> WO :lua plugin.luafiler.open()<CR>
  autocmd FileType * nnoremap <silent> WV :lua plugin.luafiler.open("v")<CR>
augroup END
```

## `g:luafiler_do_not_warn_on_start`
When a vimrc is shared with users (e.g. root and normal users) and not all the users can access `luafilesystem` module, the one see the error message.
If you want to avoid the message, set `g:luafiler_do_not_warn_on_start` with `1`

# LICENSE
MIT
