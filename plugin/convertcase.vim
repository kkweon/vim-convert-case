let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

python3 << EOF
from os.path import normpath, join
import vim
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
sys.path.insert(0, python_root_dir)

import convertcase
EOF

function! s:ToCommand(func)
  let word = expand('<cword>')
  execute 'normal ciw' . a:func(word)
endfunction

function! s:ToCommand()
python3 << EOF
import vim
word = vim.eval("<cword>")
vim.execute("'normal ciw' . {}".format(to_camel_case(word)))
EOF
endfunction

command! ToCamelCase call <SID>ToCommand()
command! ToPascalCase call <SID>ToCommand()
command! ToSnakeCase call <SID>ToCommand()
command! ToHypenCase call <SID>ToCommand()
