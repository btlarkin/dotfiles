" General
syntax on 	" Enable syntax highlighting
set number	" Show line numbers
set relativenumber	" Show relative line numbers
set tabstop=4		" Set tab width to 4 spaces
set shiftwidth=4	" Set indentation width to 4 spaces
set softtabstop=4
set expandtab		" Use spaces instead of tabs
set cursorline		" Highlight the current line
set clipboard+=unnamedplus
set noswapfile
set autoindent

" save undo trees in files
set undofile
set undodir=$HOME/.config/nvim/undo

" number of undo saved
set undolevels=10000
set undoreload=10000

" Show substitution
set inccommand=nosplit

" Key remaps
inoremap <nowait> jj <Esc>
inoremap <C-s> <Esc> :w <cr>
nnoremap <C-s> <Esc> :w <cr>
inoremap <C-q> <Esc> :q! <cr>
nnoremap <C-q> <Esc> :q! <cr>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/goyo.vim' , {'for' : 'markdown' }
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-plug'
Plug 'mattn/emmet-vim'
Plug 'alvan/vim-closetag'
Plug 'andrewradev/tagalong.vim'
call plug#end()

" Emmet
let g:user_emmet_leader_key=','
let g:user_emmet_mode='n'      " only enable normal mode functions.
let g:user_emmet_mode='inv'    " enable all functions, which is equal to
let g:user_emmet_mode='a'      " enable all function in all mode.

" Emmet HTML responsive template
let g:user_emmet_settings = {
\  'variables': {'lang' :'en'},
\  'html': {
\    'default_attributes': {
\      'option': {'value': v:null},
\      'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows':10},
\    },
\    'snippets': {
\      'html:5': "<!DOCTYPE html>\n"
\              ."<html lang=\"en\">\n" 
\              ."<head>\n"
\              ."\t<meta charset=\"${charset}\">\n"
\              ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
\              ."\t<link rel=\"stylesheet\" href=\"\">\n" 
\              ."\t<title></title>\n"
\              ."</head>\n"
\              ."<body>\n\t${child}|\n</body>\n"
\              ."</html>",
\    },
\  },
\}

" close Tag
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml,xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. '<Link>' will be closed while '<link>' won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx' : 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>'

