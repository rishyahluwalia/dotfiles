" ============= Rishy's Neovim Configuration ============= "

" Automatically install vim-plug
if empty(glob('~/.nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" ==================== Plugin Section ==================== "
call plug#begin("~/.vim/plugged")
    Plug 'joshdick/onedark.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'vim-airline/vim-airline'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " js, jsx, ts, tsx syntax highlighters
    Plug 'pangloss/vim-javascript'
    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'yuezk/vim-js'
    " end syntax highlighters
    Plug 'tpope/vim-surround'
    Plug 'preservim/nerdcommenter'
    Plug 'airblade/vim-gitgutter/'
    Plug 'tpope/vim-fugitive'
    Plug 'jiangmiao/auto-pairs'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'psliwka/vim-smoothie'
call plug#end()

" ==================== config section ==================== "
syntax on 
set termguicolors
colorscheme onedark

set encoding=utf-8
"set number
"set relativenumber
set relativenumber number
set cursorline
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set showcmd
set showmatch
set incsearch
set hlsearch
set clipboard=unnamed
set mouse=a
set lazyredraw
set updatetime=4000
nnoremap <leader><space> :nohlsearch<CR>
" open new split panes to right and below
set splitright
set splitbelow
"set virtualedit=onemore
" Move vertically by visual line
nnoremap j gj
nnoremap k gk

" Allows you to close current buffer and go to next available buffer
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>
" Open vimrc for edit
nnoremap <leader>vi :e $MYVIMRC<CR>
" Allows you to navigate buffers using [ and ]
nnoremap <leader>[ :bp<CR>
nnoremap <leader>] :bn<CR>

" ==================== NerdTree Config ==================== " 
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle NerdTree
nnoremap <silent> <C-b> :NERDTreeToggle<CR>
" Make NerdTree stick to side when opening new tabs
"autocmd VimEnter * NERDTree
"autocmd BufWinEnter * NERDTreeMirror
"autocmd VimEnter * wincmd w

" ==================== Airline Config ===================== "
let g:airline#extensions#tabline#enabled = 1
" Just show the filename (no path) in the tab
let g:airline#extensions#tabline#fnamemod = ':t'

" ================== Fuzzy Search Config ================== "
nnoremap <C-p> :FZF<CR>
"let g:fzf_prefer_tmux = 1
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}
" Let fzf user the_silver_searcher as it's default engine
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let $FZF_DEFAULT_OPTS='--color --no-reverse'
" Allows you to search within files
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>

"nnoremap <silent> K :call SearchWordWithAg()<CR>
"vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>

function! SearchWordWithAg()
  execute 'Ag' expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Ag' selection
endfunction

" ================ Coc Intellisense Config ================ "
let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver']
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
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" ==================== Nerd Commenter ==================== "
filetype plugin on

" ==================== Newbie Crutches ==================== "
"" Remove newbie crutches in Command Mode
"cnoremap <Down> <Nop>
"cnoremap <Left> <Nop>
"cnoremap <Right> <Nop>
"cnoremap <Up> <Nop>

"" Remove newbie crutches in Insert Mode
"inoremap <Down> <Nop>
"inoremap <Left> <Nop>
"inoremap <Right> <Nop>
"inoremap <Up> <Nop>

"" Remove newbie crutches in Normal Mode
"nnoremap <Down> <Nop>
"nnoremap <Left> <Nop>
"nnoremap <Right> <Nop>
"nnoremap <Up> <Nop>

"" Remove newbie crutches in Visual Mode
"vnoremap <Down> <Nop>
"vnoremap <Left> <Nop>
"vnoremap <Right> <Nop>
"vnoremap <Up> <Nop>
