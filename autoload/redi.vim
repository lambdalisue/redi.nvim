let s:Config = vital#redi#import('Config')
let s:Path = vital#redi#import('System.Filepath')
let s:_active_pyversion = 0


function! redi#config(sfile, options) abort
  return s:Config.define(s:translate(a:sfile), a:options)
endfunction

function! redi#complete() abort
  if pumvisible()
    return "\<C-n>"
  else
    return "\<C-x>\<C-o>\<C-p>\<CR>"
  endif
endfunction


" Private --------------------------------------------------------------------
function! s:translate(sfile) abort
  let path = s:Path.unixpath(a:sfile)
  let name = matchstr(path, 'autoload/\zs\%(redi\.vim\|redi/.*\)$')
  let name = substitute(name, '\.vim$', '', '')
  let name = substitute(name, '/', '#', 'g')
  let name = substitute(name, '\%(^#\|#$\)', '', 'g')
  return 'g:' . name
endfunction


" Default variable -----------------------------------------------------------
call redi#config(expand('<sfile>'), {
      \ 'enable_default_mappings': 1,
      \ 'enable_default_omnifunc': 1,
      \ 'enable_signature_indicator': 0,
      \ 'configure_deoplete': 1,
      \})
