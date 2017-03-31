nnoremap <silent><buffer> <Plug>(redi-signature-show)
      \ :<C-u>call redi#signature#show()<CR>

if g:redi#enable_default_mappings
  nmap <buffer> <C-g> <Plug>(redi-signature-show)
endif

if g:redi#enable_default_omnifunc
  setlocal omnifunc=redi#completion#complete
endif

if !exists('s:loaded')
  let s:loaded = 1
  if g:redi#signature#activate_on_startup
    call redi#signature#activate()
  endif

  if g:redi#configure_deoplete
    let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})
    let g:deoplete#omni_patterns.python =
          \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
  endif
endif
