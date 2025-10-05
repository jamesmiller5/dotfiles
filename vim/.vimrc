" Some options are commented out as they are set by default. I keep them here
" as a reminder that they exist and as a reference for future me.
set nocompatible "It's OK to not be vi compatible.

" Basics - I only really need 3 things - line numbers, syntax highlighting,
" and the mouse. In that order.
set number "Show line numbers.
" set nobackup "Don't create ~filename backups.

" Mouse
set mouse=a "Turn on the mouse TODO should be v? Makes it easier to copy from :term.
set selectmode-=mouse " Mouse doesn't trigger select mode (like visual, but worse).
" set backspace=indent,eol,start "backspace works in insert mode, much more user-friendly.

" Input
"imap <C-?> <BS> "Backspace on some SunOS systems.
"imap <C-H> <BS> "'Regular' backspace.
"inoremap <BS>   "Restore default terminal backspace.

" Search
set hlsearch " Hightlight search results.
set ignorecase "Allow case ignorance when searching.
set smartcase "Override ignorecase if any search character is uppercase, see :help smartcase for advanced usage.

" Indenting
set autoindent
set smartindent
set smarttab
"See :help softtabstop
"See :retab

" Windows and Splits
"set splitbelow "Good idea, maybe will turn on.
set splitright "Want this by default since I read left to right.
"Upgrade the status line to give more usefull information
set statusline=%F\ %m%r%w%y\ %=(%L\ loc)\ [#\%03.3b\ 0x\%02.2B]\ \ %l,%v\ \ %P
set laststatus=2 "Make statusline always on
set cmdheight=2 "default command line number of lines, 2 makes it easier to read

" Movement
set scrolloff=4 "Keep 4 lines at minimum above & below the cursor when scrolling around a file
"Wrap visual selections with chars, lets % jump to matching chars.
:vnoremap ( "zdi(<C-R>z)<ESC>
:vnoremap { "zdi{<C-R>z}<ESC>
:vnoremap [ "zdi[<C-R>z]<ESC>
:vnoremap ' "zdi'<C-R>z'<ESC>
:vnoremap " "zdi"<C-R>z"<ESC>

" Code Folding
filetype plugin indent on
set foldenable
set foldmethod=indent
set foldlevel=2 " Start folding at one syntax/indent level.

" Gui
" set guioptions+=b "Show bottom scrollbar when in gvim.

" Misc
set showcmd "Show partial commands in the last line of the screen.
set nowrap "don't wrap lines longer than the screen's width.
"Printing (:hardcopy) options.
set printoptions=paper:letter,syntax:y,number:y,duplex:off,left:5pc

" Noptions. Things I dont use but want to remember.
"set cursorline "Underline the current line the cursor is on.
"set incsearch "highlight search matches as typed, may jar your mind while it jumps around the file.

" Tab completion
set wildmode=longest,list,full
" Windsurf/Codeium
let g:codeium_enabled = v:true
"let g:codeium_enabled = v:false "Disable Codeium by default. <sad-face>.
let g:codeium_filetypes = {
	\ "": v:false,
	\ "text": v:false,
	\ "log": v:false,
	\ "markdown": v:false,
	\ "netrw": v:false,
	\ "netrc": v:false,
	\ }
if function("codeium#GetStatusString") != 0
	set statusline+=🤖%3{codeium#GetStatusString()}
endif
" Enable basic tab completion when Codeium is disabled or not installed.
if g:codeium_enabled == v:false || function("codeium#GetStatusString") == 0
	" Remap the tab key to select action with InsertTabWrapper
	inoremap <tab> <c-r>=InsertTabWrapper()<cr>
endif

" RECOMMENDED from the online "vimregex.com" simple repeat capture.
" noremap ;; :%s:::g<Left><Left><Left>
" noremap ;' :%s:::cg<Left><Left><Left><Left>

"TODO try :help usr_toc.txt -
"TODO setup autoformatting
"TODO setup autolinting
"TODO setup entr/build loop
"TODO try AutoMake

" Use :helptags ~/.vim/doc to generate help tags.

" Autocommands
if has("autocmd")
	augroup vimrc
		" Trim Trailing white space on general files
		autocmd FileType c,cpp,java,php,js,css,xml,xsl,s,go,txt,sh,python,yaml,vim,make autocmd BufWritePre * :%s/[ \t\r]\+$//e
		" XXX watch out for .md files, they need spaces at EOL to denote a line-break x.x .
		" TODO trim trailing newlines.

		"Check spelling when writing commits. Use 'z=' with the cursor on a word for
		"suggested spelling. Check :help spell for more info
		autocmd FileType gitcommit setlocal spell | setlocal colorcolumn=80 | setlocal textwidth=80

		"Python max line width.
		autocmd FileType python setlocal colorcolumn=180 | setlocal textwidth=180
	augroup END

	augroup Indent
		autocmd!
		" TODO check :help DetectIndent if these are still valid.
		" To prefer 'expandtab' to 'noexpandtab' when no detection is possible:
		" let g:detectindent_preferred_expandtab
		" To specify a preferred indent level when no detection is possible:
		" let g:detectindent_preferred_indent = 4  "should be tabstop
		autocmd BufNewFile,BufReadPost,FileReadPost,FilterReadPost,StdinReadPost * :DetectIndent
	augroup END

	augroup Folds
		autocmd!
		autocmd FileType sh let g:sh_fold_enabled=7 " Number of lines to turn into a fold.
		autocmd FileType sh let g:is_bash=1
		autocmd FileType sh set foldmethod=syntax

		" Disable folding for these types of files.
		autocmd FileType vim,gitcommit set nofoldenable
	augroup END

	augroup TransparentBackground
		autocmd!
		"Allow transparent backgrounds
		autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
	augroup END

	augroup AutoMake
		autocmd!
		autocmd BufWritePost * call Automake()
	augroup END

	augroup RestoreCursor
		autocmd!
		autocmd BufReadPost *
			\ let line = line("'\"")
			\ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
			\      && index(['xxd', 'gitrebase'], &filetype) == -1
			\      && !&diff
			\ |   execute "normal! g`\""
			\ | endif
	augroup END

	augroup GitRebase
		autocmd!
		autocmd FileType gitrebase ++once call GitRebaseDetails()
		autocmd FileType gitrebase syntax on
	augroup END
endif

"Nvim specific settings
if has("nvim")
	"Behave like vim for terminal
	autocmd TermOpen * startinsert

	" Escape insert mode while in terminal.
	tnoremap <Esc> <C-\><C-n>
	" Allow Ctrl-w to switch windows like a regular vim window.
	tnoremap <C-w> <C-\><C-n><C-w>w

	" Attempt to make terminal behave like vim terminals aka (:term is a new buffer w/ a terminal).
	" Neovim author(s) are against this behavior intentionally.
	" :ls<CR>
	"cnoremap term new \| term<CR>
	"cnoremap bd 'new | term'
	"cnoreabbrev <expr> term getcmdtype() == ":" && getcmdline() == 'term' ? 'new | term' : 'bd'

	"Colors
	try
		colorscheme Tomorrow-Night-Bright
		catch
		try
			colorscheme vim
		catch
		endtry
	endtry
else
	silent! colorscheme Tomorrow-Night-Bright
endif

" Finally, turn on syntax highlighting. Last command as other commands setup
" how the syntax highlighting is done.
syntax on

" Functions

" Diffing
" Came from :help usr_05.txt.
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
" Made this myself to diff the current file with the git HEAD version.
function! GitDiffOutput()
	let l:path = system("git ls-files --full-name " . expand("%"))
	if v:shell_error != 0
		echo "Command failed (".v:shell_error.") with output: " . l:path
		return
	endif
	let l:output = system("git show HEAD:" . l:path)
	if v:shell_error != 0
		echo "Command failed (".v:shell_error.") with output: " . l:output
		return
	endif
	diffthis
	vert new
	setlocal buftype=nofile
	put =l:output
	0d_
	diffthis
endfunction
command! DiffGit call GitDiffOutput()

function! GitRebaseDetails()
	let l:stdin_content = join(getline(1, '$'), "\n")
	let l:output = system("sed 's/\\#.*//g' | sed '/^$/d' | awk '{print $2}' | xargs git show --stat --oneline", l:stdin_content)
	if v:shell_error != 0
		echo "Command failed (".v:shell_error.") with output: " . l:output
		return
	endif
	vert new
	setlocal buftype=nofile
	setlocal filetype=gitrebase
	put =l:output
	0d_
endfunction
command! GitRebaseDetails call GitRebaseDetails()

" Automake using a screen window. Simply have a screen nammed $something-test.
function! Automake()
	if !$STY
		"echo "Not in a screen" "for debugging, be silent if no screen
		return
	endif
	let sty = strpart(matchstr($STY,"\\..*"), 1)
	silent! exec "!screen -p 0 -S ".sty."-test -X eval 'stuff make ^M'" | redraw!
endfunction

" Autocompletion using the TAB key.
" This function determines, whether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion (ctrl+p or ctrl+n).
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
