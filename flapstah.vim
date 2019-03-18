set nocompatible
set backspace=indent,eol,start

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Activate pathogen, then activate all the bundles
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add packages (vim8 onwards)
packadd! matchit
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists("*MyDiff")
	set diffexpr=MyDiff()
	function MyDiff()
		let opt = '-a --binary '
		if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		let arg1 = v:fname_in
		if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		let arg2 = v:fname_new
		if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		let arg3 = v:fname_out
		if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		let eq = ''
		if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
				let cmd = '""' . $VIMRUNTIME . '\diff"'
				let eq = '"'
			else
				let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		else
			let cmd = $VIMRUNTIME . '\diff'
		endif
		silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' .arg3 . eq
	endfunction
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically cd into the directory that the file is in
"autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General miscellany
"set textwidth=80
set number
set selection=exclusive
set cindent

" Searching
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" Mappings to make search stepping centre around the line containing the find
map N Nzz
map n nzz

" Sensible screen-oriented line editing
set wrap
nnoremap j gj
nnoremap k gk

" Tabbed windows
set tabpagemax=999
map <C-M-F4> :tabclose<CR>

" Set default window size (if appropriate)
if has ("gui_running")
	" GUI is running or is about to start
	" Set gvim window size
	set lines=40
	set columns=128
else
	" This is console Vim so don't bother changing anything
endif

" tab complete will now work how a bash shell works
set wildmode=longest,list

" increase the size of the history buffer
set history=200

" possible file formats in expected order of frequency
set fileformats=unix,dos,mac

" Execute a macro over a visual range
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
	echo "@".getcmdline()
	execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Allow the . formula to be applied over the visual range
xnoremap . :normal .<CR>

" fix up the tag function to show the full list instead of the first match
map <C-]> :tjump <C-R>=expand("<cword>")<CR><CR>
" fix all uses of ta->tj as the new ta is fixed and want it to call tj instead
cabbrev ta tj

" Since I use CMake and always build out-of-source, I use a custom shell
" script 'make' to do the build.  Normally I call it from the shell with
" $ ./make
" but Vim's :make command wants to call 'make' directly, so I tell Vim to use
" my shell script instead with the makeprg option
set makeprg=./make
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

colorscheme desert

" Rainbow Parentheses
au VimEnter * RainbowParenthesesToggleAll
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
"au Syntax * RainbowParenthesesLoadChevrons
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimcasts.org #1 - Show Invisibles
" http://vimcasts.org/episodes/show-invisibles/
"
" Shortcut to rapidly toggle `set list` - remember that the <leader> is
" usually \ (unless you have remapped it)
nmap <leader>l :set list!<CR>

" Set symbols for tabstops, EOLs and trailing whitespace
set listchars=tab:»·,eol:¶,trail:¤

"Invisible character colours
"highlight NonText guifg=#ff01d2
"highlight SpecialKey guifg=#ff01d2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimcasts.org #2 - Tabs and Spaces
" http://vimcasts.org/episodes/tabs-and-spaces/
set tabstop=2
set shiftwidth=2
set softtabstop=2
set noexpandtab

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
	let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
	if l:tabstop > 0
		let &l:sts = l:tabstop
		let &l:ts = l:tabstop
		let &l:sw = l:tabstop
	endif
	call SummeriseTabs()
endfunction

command! -nargs=* SummeriseTabs call SummeriseTabs()
function! SummeriseTabs()
	try
		echohl ModeMsg
		echon 'tabstop='.&l:ts
		echon ' shiftwidth='.&l:sw
		echon ' softtabstop='.&l:sts
		if &l:et
			echon ' expandtab'
		else
			echon ' noexpandtab'
		endif
	finally
		echohl None
	endtry
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General autocmd configuration
if has("autocmd")
	" Source the vimrc file after saving it
	autocmd bufwritepost .vimrc source $MYVIMRC
	autocmd bufwritepost flapstah.vim source $MYVIMRC

	" Vimcasts.org #3 - Whitespace preferences and filetypes
	" http://vimcasts.org/episodes/whitespace-preferences-and-filetypes/
	" Enable file type detection
	filetype plugin indent on

	" Syntax of these languages is fussy over tabs Vs spaces
	autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
	autocmd FileType python setlocal ts=2 sts=2 sw=2 noexpandtab
	autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimcasts.org #4 -	Tidying whitespace
" http://vimcasts.org/episodes/tidying-whitespace/
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
" _$ will remove all trailing whitespace in the entire file
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
" _= will auto indent the entire file
nmap _= :call Preserve("normal gg=G")<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Additional stuff to unify newlines to unix format
"nmap _n :call Preserve("update | e ++ff=dos | setlocal ff=unix | w")<CR>
function! UnifyNewlines()
	:update
	:edit ++ff=dos
	:setlocal ff=unix
	:write
endfunction
nmap _% :call Preserve("call UnifyNewlines()")<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimcasts.org #5 -	Indentation commands
" http://vimcasts.org/episodes/indentation-commands/
"
" command		action
" >					shift right
" <					shift left
" =					auto indent
"
" Keep visual block selected when altering indentation levels
vmap > >gv
vmap < <gv
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimcasts.org #6 -	Working with buffers
" http://vimcasts.org/episodes/working-with-buffers/
"
" command		action
" :ls				show the buffer list
" :bn				open the next buffer in the current window (cycles from the end of
"						the list to the beginning)
"	:bp				open the previous buffer in the current window (cycles from the
"						start of the list to the end)
"	CTRL-^		switch to the alternate file
"
"	A buffer is marked as "hidden" if it has unsaved changes, and it is not
"	currently loaded in a window.  If you try and quit Vim while there are
"	hidden buffers, you will raise an error: E162: No write since last change
"	for buffer "a.txt".  By default, Vim makes it difficult to create hidden
"	buffers.  To make Vim more liberal about hidden buffers, use the following:
set hidden
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimcasts.org #7 -	Working with windows
" http://vimcasts.org/episodes/working-with-windows/
"
" Opening split windows:
" command								action
"	CTRL-w s							split the current window horizontally, loading the same
"												file in the new window
"	CTRL-w v							split the current window vertically, loading the same
"												file in the new window
" :sp[lit] <filename>		split the current window horizontally, loading
"												<filename> in the new window
" :vsp[lit] <filename>	split the current window vertically, loading <filename>
"												in the new window
"
" Closing split windows:
" command								action
" :q[uit]								close the currently active window
"	:on[ly]								close all windows except the currently active window
"
"	Changing focus between windows:
" command								action
" CTRL-w w							cycle between the open windows
" CTRL-w h							focus the window to the left
" CTRL-w j							focus the window to the bottom
" CTRL-w k							focus the window to the top
" CTRL-w l							focus the window to the right
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
"
" Resizing windows:
" command								action
"	CTRL-w +							increase height of current window by 1 line
"	CTRL-w -							decrease height of current window by 1 line
"	CTRL-w _							maximise height of current window
"	CTRL-w |							maximise width of current window
" CTRL-w =							equalise the size of the windows
"
"	Moving windows:
" command								action
"	CTRL-w r							rotate all windows
"	CTRL-w R							rotate all windows backwards
"	CTRL-w x							exchange current window with its neighbour
"	CTRL-w H							move current window to far left
"	CTRL-w J							move current window to bottom
"	CTRL-w K							move current window to top
"	CTRL-w L							move current window to far right
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Adds tab sorting by tab name (I find the default tab sort unintuitive)
func! CurTabFileName( )
  return fnamemodify(bufname(winbufnr(tabpagewinnr(0))), ':t')
endfun
func! TabSort()
  for i in range(tabpagenr('$'), 1, -1)
    :tabr
    for j in range(1,i-1)
      let t1 = CurTabFileName()
      :tabn
      let t2 = CurTabFileName()
      if t2 < t1
        tabp
        exec ":tabmove ".j
      endif
    endfor
  endfor
endfun
command! TabSort :call TabSort()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Format the text as if it were JSON
function! FormatJSON() range
"	:execute a:firstline . "," . a:lastline . 'y'
"	let selection = @@
"	let selection = substitute(selection, ",", ",\n", "ge")
"	let selection = substitute(selection, "{", "{\n", "ge")
"	let selection = substitute(selection, "}", "\n}", "ge")
"	let selection = substitute(selection, "\[", "\[\n", "ge")
"	let selection = substitute(selection, "\]", "\n\]", "ge")
"	let @@ = selection
"	normal! V""pv%=

	:execute a:firstline . "," . a:lastline . "!python -m json.tool"
endfunction
command! -range FormatJSON :call FormatJSON()

"N.B. the following only works with single JSON objects
nmap =j :call FormatJSON()<CR>
vmap =j :call FormatJSON()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search for selected text, forwards or backwards.
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Complete options (disable preview scratch window)
"set completeopt = menu,menuone,longest
" Limit popup menu height
"set pumheight=15

"SuperTab option for context aware completion
"let g:SuperTabDefaultCompletionType = "context"

" Disable auto popup, use <Tab> to autocomplete
"let g:clang_complete_auto = 0

" Show clang errors in the quickfix window
let g:clang_complete_copen = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
