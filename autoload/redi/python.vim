let s:major_version = 0
let s:py2_enabled = has('python')
let s:py3_enabled = has('python3')


function! redi#python#current() abort
  if s:major_version == 0
    call redi#python#activate(g:redi#python#force_py_version)
  endif
  return s:major_version
endfunction

function! redi#python#activate(...) abort
  if !s:py2_enabled && !s:py3_enabled
    call redi#console#error('python2 nor python3 interfaces are not available.')
    return 1
  elseif !s:py2_enabled
    return redi#python#activate3()
  elseif !s:py3_enabled
    return redi#python#activate2()
  endif
  " Both python2/python3 are available
  let pyversion = a:0 && !empty(a:1) ? a:1 : s:get_pyversion()
  if pyversion == 2
    return redi#python#activate2()
  else
    return redi#python#activate3()
  endif
endfunction

function! redi#python#activate2() abort
  if !s:py2_enabled
    call redi#console#error('A python2 interface is not available.')
    return 1
  endif
  let s:major_version = 2
endfunction

function! redi#python#activate3() abort
  if !s:py3_enabled
    call redi#console#error('A python3 interface is not available.')
    return 1
  endif
  let s:major_version = 3
endfunction


" Private --------------------------------------------------------------------
function! s:get_pyversion() abort
  " Guess from 'python' executable
  silent let result = system('python --version')
  if v:shell_error
    return g:redi#python#force_py_version ? g:redi#python#force_py_version : 3
  else
    return result =~# '^\w\+ 2\.' ? 2 : 3
  endif
endfunction


" Default config -------------------------------------------------------------
call redi#config(expand('<sfile>'), {
      \ 'force_py_version': 0,
      \})
