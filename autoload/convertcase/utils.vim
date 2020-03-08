function! s:HasUnderscore(text)
  return a:text =~ '_'
endfunction

function! s:HasUpperAscii(text)
  return a:text =~# '[A-Z]'
endfunction

function! convertcase#utils#IsCamelCase(text)
  return s:HasUpperAscii(a:text) && !s:HasUnderscore(a:text)
endfunction

function! convertcase#utils#IsSnakeCase(text)
  return s:HasUnderscore(a:text)
endfunction

function! convertcase#utils#IsHypenCase(text)
  return a:text =~ '-'
endfunction

function! convertcase#utils#IsPascalCase(word)
    if len(a:word) == 0
        return 0
    endif

    return a:word[0] =~# '[A-Z]' && convertcase#utils#IsCamelCase(a:word)
endfunction


function! convertcase#utils#Split(text, f, include_split)
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

function! convertcase#utils#ToSnakeCase(word)
    if convertcase#utils#IsHypenCase(a:word)
        let words = convertcase#utils#Split(tolower(a:word), { c -> c == '-' }, 0)
        return join(words, '_')
    endif

    if convertcase#utils#IsCamelCase(a:word)
        let words = convertcase#utils#Split(a:word, { c -> c=~# '[A-Z]' }, 1)
        return join(map(words, {_, val -> tolower(val) }), '_')
    endif
    return a:word
endfunction

function! convertcase#utils#ToCamelCase(word)
    if convertcase#utils#IsHypenCase(a:word)
        let words = convertcase#utils#Split(tolower(a:word), { c -> c == '-' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        let camelcased_word = join(words, '')
        return tolower(camelcased_word[0]) . camelcased_word[1:]
    elseif convertcase#utils#IsPascalCase(a:word)
        return tolower(a:word[0]) . a:word[1:]
    elseif convertcase#utils#IsSnakeCase(a:word)
        let words = convertcase#utils#Split(tolower(a:word), { c -> c == '_' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        let camelcased_word = join(words, '')
        return tolower(camelcased_word[0]) . camelcased_word[1:]
    endif

    return a:word
endfunction

function! convertcase#utils#ToPascalCase(word)
    if convertcase#utils#IsHypenCase(a:word)
        let words = convertcase#utils#Split(tolower(a:word), { c -> c == '-' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        return join(words, '')
    elseif convertcase#utils#IsSnakeCase(a:word)
        let words = convertcase#utils#Split(tolower(a:word), { c -> c == '_' }, 0)
        let words = map(words, {_, w -> toupper(w[0]) . w[1:] })
        return join(words, '')
    elseif convertcase#utils#IsCamelCase(a:word)
        return toupper(a:word[0]) . a:word[1:]
    endif

    return a:word
endfunction

function! convertcase#utils#ToHypenCase(word)
    if convertcase#utils#IsCamelCase(a:word) || convertcase#utils#IsPascalCase(a:word)
        let words = convertcase#utils#Split(a:word, { c -> c =~# '[A-Z]' }, 1)
        return join(map(words, { _, w -> tolower(w) }), '-')
    elseif convertcase#utils#IsSnakeCase(a:word)
        let words = convertcase#utils#Split(a:word, { c -> c == '_' }, 0)
        return join(words, '-')
    endif
    return a:word
endfunction
