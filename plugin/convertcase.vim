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

function! IsHypenCase(text)
  return a:text =~ '-'
endfunction

function! Split(text, f, include_split)
  let l:result = []
  let l:temp = ''

  " split by each character :help \zs
  for c in split(a:text, '\zs')
    if a:f(c)
      if 0 < len(l:temp)
        let l:result = add(l:result, l:temp)
        let l:temp = ''
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
    if IsHypenCase(a:word)
        let words = Split(tolower(a:word), { c -> c == '-' }, 0)
        return join(words, '_')
    endif

    if IsCamelCase(a:word)
        let words = Split(a:word, { c -> c=~# '[A-Z]' }, 1)
        return join(map(words, {_, val -> tolower(val) }), '_')
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
    if IsHypenCase(a:word)
        let words = Split(tolower(a:word), { c -> c == '-' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        let camelcased_word = join(words, '')
        return tolower(camelcased_word[0]) . camelcased_word[1:]
    elseif IsPascalCase(a:word)
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
    if IsHypenCase(a:word)
        let words = Split(tolower(a:word), { c -> c == '-' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        return join(words, '')
    elseif IsSnakeCase(a:word)
        let words = Split(tolower(a:word), { c -> c == '_' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        return join(words, '')
    elseif IsCamelCase(a:word)
        return toupper(a:word[0]) . a:word[1:]
    endif

    return a:word
endfunction

function! ToHypenCase(word)
    if IsCamelCase(a:word) || IsPascalCase(a:word)
        let words = Split(a:word, { c -> c =~# '[A-Z]' }, 1)
        return join(map(words, { _, w -> tolower(w) }), '-')
    elseif IsSnakeCase(a:word)
        let words = Split(a:word, { c -> c == '_' }, 0)
        return join(words, '-')
    endif
    return a:word
endfunction

function! s:ToCommand(func)
    execute 'set iskeyword+=-'
    let word = expand('<cword>')
    execute 'normal ciw' . a:func(word)
    execute 'set iskeyword-=-'
endfunction

command! ToCamelCase call <SID>ToCommand({ w -> ToCamelCase(w) })
command! ToPascalCase call <SID>ToCommand{ w -> ToPascalCase(w) })
command! ToSnakeCase call <SID>ToCommand({ w -> ToSnakeCase(w) })
command! ToHypenCase call <SID>ToCommand({ w -> ToHypenCase(w) })
