function! s:hasUnderscore(text)
  return a:text =~ '_'
endfunction

function! s:hasUpperAscii(text)
  return a:text =~# '[A-Z]'
endfunction

function! IsCamelCase(text)
  return <SID>hasUpperAscii(a:text) && !<SID>hasUnderscore(a:text)
endfunction

function! IsSnakeCase(text)
  return <SID>hasUnderscore(a:text)
endfunction

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
      else
        let l:temp .= c
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

function! ToSnakeCase(word)
    if IsCamelCase(a:word)
        let words = Split(a:word, { c -> c=~# '[A-Z]' }, 1)
        return join(map(words, {_, val -> tolower(val) }), "_")
    endif
    return a:word
endfunction
