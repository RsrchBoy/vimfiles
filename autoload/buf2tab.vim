" Write bufexplorer's t:bufexp_buf_list to the sessionfile!  (or try to)

function! buf2tab#SaveTabInfo() abort

    " no point if we're not in a session
    if !len(v:this_session) || exists('SessionLoad') | return | endif

    let l:lines = []

    for l:tabnr in range(tabpagenr('$'))

        let l:buf_names = copy(gettabvar(l:tabnr, 'bufexp_buf_list', []))

        call filter(l:buf_names, { k, v -> getbufvar(v, '&buftype') !=# 'nofile' })
        call filter(l:buf_names, { k, v -> buflisted(v)                          })
        call    map(l:buf_names, { k, v -> bufname(v)                            })
        call filter(l:buf_names, { k, v -> v !=# '[BufExplorer]'                 })

        let l:lines += [
            \   'call settabvar('. l:tabnr . ', ' .
            \   "'buf2tab_buf_names', ['" . join(l:buf_names, "', '") . "'])"
            \]

    endfor

    " bail if there's nothing to write
    if !len(l:lines) | return | endif

    " Store these away in a `Sessionx.vim` file
    let l:file = substitute(v:this_session, '\.vim$', 'x.vim', '')
    call writefile(l:lines, l:file)

    return
endfunction

function! buf2tab#MyRestoreTabBuffers() abort

    " we only want to do this once
    if has_key(g:, 'buf2tab_buffers_restored')
        return
    endif

    for l:page in gettabinfo()

        if !has_key(l:page.variables, 'buf2tab_buf_names') | continue | endif

        let l:names = copy(l:page.variables.buf2tab_buf_names)
        let l:bufs = []
        for l:name in l:names
            let l:bufs += [ bufnr(l:name) ]
        endfor

        let l:page.variables.bufexp_buf_list = l:bufs
    endfor

    let g:buf2tab_buffers_restored = 1
    return
endfunction

" __END__
