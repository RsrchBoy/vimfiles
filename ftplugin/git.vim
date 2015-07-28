" a couple additional settings for git type buffers

" Only do this when not done yet for this buffer
if exists("b:did_local_git_ftplugin")
    finish
endif
let b:did_local_git_ftplugin = 1

" close with a single q
nnoremap <buffer> <silent> q :q<CR>
nnoremap <buffer> <silent> F :call RunGitFixup()<CR>

" FIXME: not quite.
highlight clear ExtraWhitespace
