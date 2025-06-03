set clipboard+=unnamedplus

" key remaps
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

inoremap <nowait> jj <Esc>
inoremap <C-s> <Esc> :w <cr>
nnoremap <C-s> <Esc> :w <cr>
inoremap <C-q> <Esc> :q! <cr>
nnoremap <C-q> <Esc> :q!<cr>

" no swapfile
set noswapfile

" save undo trees in files
set undofile
set undodir=$HOME/.config/nvim/undo

" number of undo saved
set undolevels=10000
set undoreload=10000

set number

" use 4 spaces instead of tab ()
" copy indent from current line when starting a new line

set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Show substitution
set inccommand=nosplit
