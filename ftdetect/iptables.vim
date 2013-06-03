" Vim support file to detect iptables-save files
"
" Maintainer: Chris Weyl <cweyl@alumni.drew.edu> 2013

au BufNewFile,BufRead * call s:isIptables()

func! s:isIptables()
  if getline(1) =~ "^# Generated by iptables-save "
    setf iptables
  endif
endfunc
