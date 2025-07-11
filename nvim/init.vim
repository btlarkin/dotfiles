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

" horizontal window split
nnoremap <C-w>h <C-w>s

" Plugins
call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/goyo.vim' , {'for' : 'markdown' }
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-plug'
Plug 'junegunn/fzf.vim'
Plug 'chrisbra/csv.vim'
Plug 'moll/vim-bbye'
Plug 'simeji/winresizer'
Plug 'simnalamburt/vim-mundo'
Plug 'mattn/emmet-vim'
Plug 'alvan/vim-closetag'
Plug 'andrewradev/tagalong.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'MunifTanjim/prettier.nvim'

" For coc.vim to work, you'll need nodejs and yarn (both available in official repos).
" Only bash-language-server is configured with coc.vim. See the file coc-settings.json.
" To make it work, you need to install bash-language-server: `sudo pacman -S bash-language-server`
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver'

" Collection of snippets
Plug 'honza/vim-snippets'
 
" Compiler and linter
Plug 'neomake/neomake'

" Theme gruvbox
Plug 'morhetz/gruvbox'

" Status bar
Plug 'itchyny/lightline.vim'

"tmux
Plug 'wellle/tmux-complete.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'

" Man pages in Neovim
Plug 'jez/vim-superman'
call plug#end()

" Show substitution
set inccommand=nosplit

nnoremap <space> <nop>
let mapleader = "\<space>"

nnoremap <leader>bn :bn<cr> ;buffer next
nnoremap <leader>tn gt ;new tab

" Config for chrisbra/csv.vim
augroup filetype_csv
    autocmd! 

    autocmd BufRead,BufWritePost *.csv :%ArrangeColumn!
    autocmd BufWritePre *.csv :%UnArrangeColumn
augroup END

" Config for fzf.vim (BONUS :D)
nnoremap <leader>f :Files<cr>

"###########
"# coc.vim #
"###########

" Coc extensions (need to install yarn or npm, both available in official repo of Arch Linux)
let g:coc_global_extensions = [
            \ 'coc-snippets',
            \ 'coc-css', 
            \ 'coc-html',
            \ 'coc-json', 
            \ 'coc-rome',
            \ 'coc-yank',
            \ 'coc-yaml',
            \]

" This is a very basic configuration - you can do way more than that (but do you really want to?)

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"###########
"# Neomake #
"###########

" Needs to install shellcheck and vint: `sudo pacman -S shellcheck vint`

" Neomake signs in the gutter
let g:neomake_error_sign = {'text': '', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {
            \   'text': '',
            \   'texthl': 'NeomakeWarningSign',
            \ }
let g:neomake_message_sign = {
            \   'text': '',
            \   'texthl': 'NeomakeWarningSign',
            \ }
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

" update neomake when save file
call neomake#configure#automake('w')

command! -bang -nargs=* -complete=file Make NeomakeProject <args>

" Enable linters
let g:neomake_sh_enabled_makers = ['shellcheck']
let g:neomake_vim_enabled_makers = ['vint']

"###########
"# Gruvbox #
"###########

autocmd vimenter * ++nested colorscheme gruvbox 

"#############
"# lightline #
"#############

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

"#######
" Emmet
"####### 
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
"let g:closetag_close_shortcut = '<leader>'

