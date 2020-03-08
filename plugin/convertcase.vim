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

function! IsPascalCase(word)
    if len(a:word) == 0
        return 0
    endif

    return a:word[0] =~# '[A-Z]' && IsCamelCase(a:word)
endfunction

function! ToCamelCase(word)
    if IsPascalCase(a:word)
        return tolower(a:word[0]) . a:word[1:]
    elseif IsSnakeCase(a:word)
        let words = Split(tolower(a:word), { c -> c == '_' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        let camelcased_word = join(words, '')
        return tolower(camelcased_word[0]) . camelcased_word[1:]
    endif

    return a:word
endfunction


function! ToPascalCase(word)
    if IsSnakeCase(a:word)
        let words = Split(tolower(a:word), { c -> c == '_' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        return join(words, '')
    elseif IsCamelCase(a:word)
        return toupper(a:word[0]) . a:word[1:]
    endif

    return a:word
endfunction

function! s:ToCamelCaseCommand()
    let word = expand("<cword>")
    execute "normal ciw" . ToCamelCase(word)
endfunction

function! s:ToSnakeCaseCommand()
    let word = expand("<cword>")
    execute "normal ciw" . ToSnakeCase(word)
endfunction

function! s:ToPascalCaseCommand()
    let word = expand("<cword>")
    execute "normal ciw" . ToPascalCase(word)
endfunction

command! ToCamelCase call <SID>ToCamelCaseCommand()
command! ToPascalCase call <SID>ToPascalCaseCommand()
command! ToSnakeCase call <SID>ToSnakeCaseCommand()
