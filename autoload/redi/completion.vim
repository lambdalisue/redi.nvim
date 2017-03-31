function! redi#completion#complete(findstart, base) abort
  if a:findstart
    let col  = col('.')
    let part = getline('.')[col : ]
    return col + strlen(substitute(part, '[^a-zA-Z0-9]*$', '', ''))
  else
    return redi#completion#gather_candidates(a:base)
  endif
endfunction

function! redi#completion#gather_candidates(base) abort
  let pyversion = redi#python#current()
  return call(
        \ printf('_redi_completion_gather_candidates_py%s', pyversion),
        \ [a:base]
        \)
endfunction
