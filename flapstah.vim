set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Activate pathogen, then activate all the bundles
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
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
" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
  autocmd bufwritepost flapstah.vim source $MYVIMRC
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" Mappings to make search stepping centre around the line containing the find
map N Nzz
map n nzz
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
" Tabs & spaces
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
" Sensible screen-oriented line editing
set wrap
nnoremap j gj
nnoremap k gk
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabbed windows
set tabpagemax=999
map <C-M-F4> :tabclose<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visible whitespace
"
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Set symbols for tabstops and EOLs
set listchars=tab:»\ ,eol:¶

"Invisible character colours
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a49
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fix up the tag function to show the full list instead of the first match
map <C-]> :tjump <C-R>=expand("<cword>")<CR><CR>
" fix all uses of ta->tj as the new ta is fixed and want it to call tj instead
cabbrev ta tj 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map ALT-O to open the corresponding .cpp/.h file in a new tab on the right
if exists("FSRight")
	map <M-`> :tabnew
endif
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
