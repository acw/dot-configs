" Use Vim settings, rather then Vi settings (much better!).
set nocompatible

" Base directory should always be ${HOME}/.system/vim/, because I don't care
" about Windows
let $VIMHOME = $HOME . '/.system/vim/'

" Get vundle a-going. 
set rtp+=$VIMHOME/bundle/vundle
set rtp+=$VIMHOME
call vundle#rc($VIMHOME . '/bundle')

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-markdown'
Bundle 'IndentAnything'
Bundle 'tpope/vim-fugitive'
Bundle 'jcf/vim-latex'
Bundle 'eliottt/haskell-indent'
Bundle 'bling/vim-airline'
Bundle 'edkolev/tmuxline.vim'

" Airlien config
set laststatus=2
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#show_buffers  = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'

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

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("spell")
  setlocal spell spelllang=en_us
endif

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

map <Leader><Leader> to :noh<Enter>
