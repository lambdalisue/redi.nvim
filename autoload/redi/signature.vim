function! redi#signature#gather_candidates() abort
  let pyversion = redi#python#current()
  return call(
        \ printf('_redi_signature_gather_candidates_py%s', pyversion),
        \ []
        \)
endfunction

function! redi#signature#show() abort
  let signatures = redi#signature#gather_candidates()
  if empty(signatures)
    return
  endif
  let signature = signatures[0]
  echohl Function
  echon signature.call_name
  echohl None
  echon '('
  if signature.index == -1
    echohl rediSignatureParams
    echon signature.params_text
  else
    echohl rediSignatureParams
    echon signature.params_ltext
    echohl rediSignatureParamsBold
    echon signature.params_ctext
    echohl rediSignatureParams
    echon signature.params_rtext
  endif
  echohl None
  echon ') : '
  echon signature.description
endfunction

function! redi#signature#activate() abort
  let s:activated = 1
  augroup redi_signature_indicator
    autocmd! * <buffer>
    autocmd InsertEnter  <buffer> call redi#signature#show()
    autocmd CursorMovedI <buffer> call redi#signature#show()
    autocmd CompleteDone <buffer> call redi#signature#show()
  augroup END
  redraw | echo ''
endfunction

function! redi#signature#deactivate() abort
  let s:activated = 0
  augroup redi_signature_indicator
    autocmd! * <buffer>
  augroup END
  redraw | echo ''
endfunction

function! redi#signature#toggle() abort
  if get(s:, 'activated', 0)
    call redi#signature#diactivate()
    return 0
  else
    call redi#signature#activate()
    return 1
  endif
endfunction


" Highlight ------------------------------------------------------------------
function! s:define_highlights() abort
  highlight default link rediSignatureParams     Comment
  highlight default link rediSignatureParamsBold String
endfunction

augroup redi_signature_colorscheme
  autocmd! *
  autocmd ColorScheme * call s:define_highlights()
augroup END

call s:define_highlights()


" Default config -------------------------------------------------------------
call redi#config(expand('<sfile>'), {
      \ 'activate_on_startup': 1,
      \})
