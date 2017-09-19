" a couple additional settings for git type buffers

if exists('b:did_ftplugin_rsrchboy')
    finish
endif
let b:did_ftplugin_rsrchboy = 1
let b:undo_ftplugin .= ' | unlet b:did_ftplugin_rsrchboy'

let s:tools = g:rsrchboy#buffer#tools

let b:undo_ftplugin .= ' | setl foldcolumn<'
setlocal foldcolumn=0

call s:tools.nnoremap('q', ':q')
call s:tools.nnoremap('F', ':Gcommit --no-verify --fixup  HEAD <bar> call fugitive#reload_status()')
call s:tools.nnoremap('S', ':Gcommit --no-verify --squash HEAD <bar> call fugitive#reload_status()')
call s:tools.nnoremap('A', ':Git add -A <CR><bar> call fugitive#reload_status()')
