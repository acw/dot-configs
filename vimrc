" Use Vim settings, rather then Vi settings (much better!).
set nocompatible

let $VIMHOME = $HOME . '/.system/vim/'
set rtp+=$VIMHOME
set packpath=$VIMHOME

colorscheme awick

set history=50 " keep 50 lines of command line history
set textwidth=80 " wrap at 80 characters
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching
set shiftwidth=2 " how many spaces to add when tabbed
set tabstop=4 " tab is four spaces
set expandtab " please don't really insert tabs
set laststatus=2 " always show the status bar
set nobackup
set nowritebackup
set modelines=10
set nofoldenable " disable folding
set directory=~/tmp,/var/tmp/,/tmp
set number " show line numbers on the left
set title " change the terminal title sometimes maybe
set hlsearch

nnoremap <leader>p :History<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>t :Files<CR>
nnoremap <leader>f :Rg<CR>

if has("spell")
  autocmd BufRead,BufNewFile *.md setlocal spell
  autocmd BufRead,BufNewFile *.txt setlocal spell
  autocmd FileType gitcommit setlocal spell
  highlight clear SpellBad
  highlight SpellBad cterm=underline
  highlight clear SpellCap
  highlight SpellCap cterm=underline
  highlight clear SpellLocal
  highlight SpellLocal cterm=underline
  highlight clear SpellRare
  highlight SpellRare cterm=underline
endif

" Leave these here, because they're really handy once in awhile 
" set t_ku=[A
" set t_kd=[B
" set t_kl=[D
" set t_kr=[C

" Show spaces and tabs (thanks Trevor)
set list lcs=tab:>-,trail:.

" Ignore certain common file extensions that don't contain text
set wildignore=*.o,*.hi,*.d,*~,*.bak,*.swp,.git

map <Leader><Leader> to :noh<Enter>

" Coqtail
autocmd Filetype coq call coqtail#register()
autocmd Filetype coq nnoremap <buffer> <c-c><enter>       :CoqToLine<CR>
autocmd Filetype coq inoremap <buffer> <c-c><enter>  <Esc>:CoqToLine<CR>

" ALE Settings
let g:ale_cursor_detail = 1
let g:ale_completion_enabled = 1

let g:ale_fixers = {
\    '*': ['remove_trailing_lines', 'trim_whitespace'],
\    'c': ['clang-format'],
\    'cpp': ['clang-format'],
\    'rust': ['rustfmt'],
\    'sh': ['shfmt'],
\}

let g:ale_linters = {
\    'c': ['ccls'],
\    'cpp': ['ccls'],
\    'haskell': ['cabal-ghc','hie'],
\    'rust': ['analyzer'],
\}

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#show_buffers  = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#branch#empty_message  = ' '
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts                  = 1

packloadall
silent! helptags ALL
