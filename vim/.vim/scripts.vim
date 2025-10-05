if did_filetype()	" filetype already set..
	finish		" ..don't do these checks
endif
if getline(1) =~# '^#!.*/bin/env\(\s\+-S\)\?\s\+\(uv\|python\)'
	setfiletype python
elseif getline(1) =~? '\<drawing\>'
	setfiletype drawing
endif
