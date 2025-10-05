
function! s:varexpand()
	" Expand $foo to ${foo} while ignoring comments (like '# $foo') or
	" single-quoted strings (like '$foo').
	:g|^[^#\']*$|s/$\([a-zA-Z_][a-zA-Z0-9_]\+\)/${\1}/g

" Original logic, now nested in g|...| command above.
"	:%s/$\([a-zA-Z0-9_]\{2,\}\)/${\1}/g
endfunction
command! Varexpand call s:varexpand()
