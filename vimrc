" Use Vim settings, rather then Vi settings (much better!).
set nocompatible

" Base directory should always be ${HOME}/.system/vim/, because I don't care
" about Windows
let $VIMHOME = $HOME . '/.system/vim/'
set rtp+=$VIMHOME

" Get vundle a-going. 
set rtp+=$VIMHOME/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'let-def/vimbufsync'
Plugin 'dense-analysis/ale'
Plugin 'tommcdo/vim-lion'
Plugin 'airblade/vim-gitgutter'
" Plugin 'tpope/vim-markdown'
" Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim' " Tynan says to use FZF here
Plugin 'eagletmt/ghcmod-vim'
Plugin 'whonore/Coqtail'
" Plugin 'rust-lang/rust.vim'
" Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets'
" Plugin 'elliottt/vim-haskell'
" Plugin 'let-def/vimbufsync'

set laststatus=2
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#show_buffers  = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#branch#empty_message  = ' '
let g:airline_powerline_fonts                  = 1

let g:ctrlp_map = '<Space>'
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("t")': [ '<c-g>' ]
    \ }
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_extensions = [ 'mixed', 'quickfix', 'undo' ]
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_match_window = 'max:20,results:20'
let g:ctrlp_mruf_relative = 1
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.git|\.hg|\.svn|dist|dist-newstyle|target)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
nnoremap <C-@> :CtrlPBuffer<CR>


" De-prioritize all lint commands.
let g:ale_command_wrapper = 'nice -n4'
"
" Open ALE preview window when the cursor moves onto lines with problems.
let g:ale_cursor_detail = 1

" Enable auto-complete with ALE.
let g:ale_completion_enabled = 1

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'rust': ['rustfmt'],
\}

let g:ale_linters = {
\   'rust': ['rls'],
\   'haskell': ['cabal_ghc','hie'],
\}
"   'haskell': ['ghc','cabal_ghc','hie'],

" Enable clippy lints.
let g:ale_rust_rls_config = {
\   'rust': {
\     'clippy_preference': 'on'
\   }
\}

call vundle#end()

" Enable file type detection.
filetype plugin indent on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" set the terminal title as appopriate
set title

set history=50          " keep 50 lines of command line history
set textwidth=80        " wrap at 80 characters
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set shiftwidth=2        " how many spaces to add when tabbed
set tabstop=4           " tab is four spaces
set expandtab           " please don't really insert tabs
set nobackup
set nowritebackup
set modelines=10
set nofoldenable        " disable folding
set directory=~/tmp,/var/tmp/,/tmp
set number

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

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
au      BufNewFile,BufRead *.hbt setf habit
autocmd BufRead,BufNewFile *.hsc setlocal filetype=haskell

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

augroup END

" set t_ku=[A
" set t_kd=[B
" set t_kl=[D
" set t_kr=[C

colorscheme awick

map! [F <Esc>

" Show spaces and tabs (thanks Trevor)
set list lcs=tab:>-,trail:.

" Highlight lines longer than 80 chars (thanks Trevor)
let w:m80=matchadd('ErrorMsg', '\%>80v.\+', -1)

" Ignore certain common file extensions that don't contain text
set wildignore=*.o,*.hi,*.d,*~,*.bak,*.swp

"
map <Leader><Leader> to :noh<Enter>

" Coqtail
inoremap <C-Enter> :CoqToLine

" Try using par for reformatting
set formatprg="par"
