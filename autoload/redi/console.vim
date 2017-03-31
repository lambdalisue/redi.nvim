let s:Console = vital#redi#import('Vim.Console')
let s:Console.prefix = '[redi] '


function! redi#console#error(...) abort
  call call(s:Console.error, a:000, s:Console)
endfunction
