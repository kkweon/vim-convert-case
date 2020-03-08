function! s:ToCommand(func)
    execute 'set iskeyword+=-'
    let word = expand('<cword>')
    execute 'normal ciw' . a:func(word)
    execute 'set iskeyword-=-'
endfunction

command! ToCamelCase call <SID>ToCommand({ w -> convertcase#utils#ToCamelCase(w) })
command! ToPascalCase call <SID>ToCommand({ w -> convertcase#utils#ToPascalCase(w) })
command! ToSnakeCase call <SID>ToCommand({ w -> convertcase#utils#ToSnakeCase(w) })
command! ToHypenCase call <SID>ToCommand({ w -> convertcase#utils#ToHypenCase(w) })
