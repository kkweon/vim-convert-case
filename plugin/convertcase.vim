function! Split(text, f, include_split)
  let l:result = []
  let l:temp = ""

  " split by each character :help \zs
  for c in split(a:text, '\zs')
    if a:f(c)
      if 0 < len(l:temp)
        let l:result = add(l:result, l:temp)
        let l:temp = ""
        if a:include_split
          let l:temp .= c
        endif
      endif
    else
      let l:temp .= c
    endif
  endfor

  if 0 < len(l:temp)
    let l:result = add(l:result, l:temp)
  endif

  return l:result
endfunction
