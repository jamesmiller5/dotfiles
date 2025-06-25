set nocompatible "It's OK to not be vi compatible.
syntax on " Turn syntax highlighting on, this works regardless of color settings
set number " Show line numbers

"Don't create ~filename backups, very annoying to leave this on and find dozens of extra files scattered about.
set nobackup

" Turn on the mouse
set mouse=a "TODO should be v?
" Mouse doesn't trigger select mode (like visual, but worse)
set selectmode-=mouse

"This is should match your terminal background, for black-on-white choose 'light'
"set background=light

" TODO reorg this to make more sense
set backspace=indent,eol,start "backspace works in insert mode, much more user-friendly.
" TODO look into set backspace=indent,eol,start
" TODO look into set showcmd
set tabstop=4 "set tab width to 4 spaces
set shiftwidth=4 "set (auto)tab's to width of 4 spaces
"Neither of the above actually puts spaces into a file when tabbing, they simply display 4 spaces when a \t is read
set hlsearch "highlight searchs
set ignorecase "ignore case when searching
set smartcase "override ignorecase if any search character is uppercase
"set autoindent "turn on auto indent
"set smartindent "turn on smart indent
"set smarttab "TODO look up the docs
set number "show line numbers
set nowrap "don't wrap lines longer than the screen's width
set guioptions+=b "show bottom scrollbar when in gvim
set foldmethod=indent "fold code based on indents
set nofoldenable "makes sure the code is not folded when first opened, used zi to toggle
set ruler "Show line statistics in bottom left corner
" TODO unbreak this - https://vimhelp.org/usr_05.txt.html#05.3
set showcmd "Show in-progress command strings in the lower right
set scrolloff=4 "Keep 4 lines at minimum above & below the cursor when scrolling around a file

"These options are personal preference
"set cursorline "Underline the current line the cursor is on.
"set incsearch "highlight search matches as typed, may jar your mind while it jumps around the file

"Upgrade the status line to give more usefull information
set statusline=%F\ %m%r%w%y\ %=(%L\ loc)\ [#\%03.3b\ 0x\%02.2B]\ \ %l,%v\ \ %P
set laststatus=2 "Make statusline always on
set cmdheight=2 "default command line number of lines, 2 makes it easier to read

"Printing (:hardcopy) options
set printoptions=paper:letter,syntax:y,number:y,duplex:off,left:5pc

"Enable filetype's
"filetype plugin indent on

"Wrap visual selections with chars
:vnoremap ( "zdi(<C-R>z)<ESC>
:vnoremap { "zdi{<C-R>z}<ESC>
:vnoremap [ "zdi[<C-R>z]<ESC>
:vnoremap ' "zdi'<C-R>z'<ESC>
:vnoremap " "zdi"<C-R>z"<ESC>

"If your having trouble with the backspace character, try uncommenting these
"imap <C-?> <BS>
"imap <C-H> <BS>
"inoremap <BS>

" Automake using a screen window
function! Automake()
	if !$STY
		"echo "Not in a screen" "for debugging, be silent if no screen
		return
	endif
	let sty = strpart(matchstr($STY,"\\..*"), 1)
	silent! exec "!screen -p 0 -S ".sty."-test -X eval 'stuff make ^M'" | redraw!
endfunction

" Autocompletion using the TAB key
" This function determines, whether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

if has("autocmd")
	" Have Vim jump to the last position when reopening a file
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
				\| exe "normal! g'\"" | endif

	" Trim Trailing white space on general files
	autocmd FileType c,cpp,java,php,js,css,xml,xsl,s,go autocmd BufWritePre * :%s/[ \t\r]\+$//e

	"Automake on save
	autocmd BufWritePost * call Automake()

	"Check spelling when writing commits. Use 'z=' with the cursor on a word for
	"suggested spelling. Check :help spell for more info
	autocmd FileType gitcommit setlocal spell
endif

if has("autocmd")
	" Have Vim jump to the last position when reopening a file.
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
							\| exe "normal! g'\"" | endif

	" Trim trailing whitespace on general files
	" TODO update this list
	autocmd FileType vim,c,cpp,java,php,js,css,xml,xsl,s,go,txt,sh autocmd BufWritePre * :%s/[ \t\r]\+$//e
	" XXX watch out for .md files, thye need spaces at EOL to denote a line-break x.x

	"Check spelling when writing commit messages. Use 'z=' with the cursor on a word for suggested spelling.
	"Check :help spell for more info.
	autocmd FileType gitcommit setlocal spell | setlocal colorcolumn=80 | setlocal textwidth=80

	"Python max line width. TODO adjust
	autocmd FileType python setlocal colorcolumn=120 | setlocal textwidth=80
endif

"TODO setup autoformatting
"TODO setup autolinting
"TODO setup entr/build loop aka Automake

"Upgrade the status line to give more useful information.
set statusline=%F\ %m%r%w%y\ %=(%L\ loc)\ [#\%03.3b\ 0x\%02.2B]\ \ %l,%v\ \ %P
set laststatus=2 "Make statusline always on.
set cmdheight=2 "default command line number of lines, 2 makes it easier to read the last command.

"Nvim specific settings
if has("nvim")
		"Remove line numbers in terminal mode
		autocmd TermOpen * setlocal nonumber norelativenumber

		"TODO Backup coloscheme
		"colorscheme vim
endif

"TODO colorscheme test and fall-back
"colorscheme Tomorrow-Night-Bright

"TODO Allow transparent backgrounds
"highlight Normal guibg=NONE ctermbg=NONE

"TODO Other configs
" Recommends

" TODO other ideas
" set wildmode=longest,list,full

" TODO deduplicate.
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

" TODO Document. Came from :help usr_05.txt
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
			\ | wincmd p | diffthis

" TODO try :help usr_toc.txt -

" DetectIndent config
augroup DetectIndents
	autocmd!
	autocmd BufReadPost * :DetectIndent
augroup END
" To prefer 'expandtab' to 'noexpandtab' when no detection is possible:
" let g:detectindent_preferred_expandtab
" To specify a preferred indent level when no detection is possible:
" let g:detectindent_preferred_indent = 4  "should be tabstop

" TODO Other configs from job.
" Windsurf config
