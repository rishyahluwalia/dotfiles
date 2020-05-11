" ============= Rishy's Neovim Configuration ============= "

" ==================== Plugin Section ==================== "
call plug#begin("~/.vim/plugged")
    Plug 'lifepillar/vim-solarized8'
    Plug 'joshdick/onedark.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " js, jsx, ts, tsx syntax highlighters
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'pangloss/vim-javascript'
    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'yuezk/vim-js'
    " end syntax highlighters
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'airblade/vim-gitgutter/'
    Plug 'tpope/vim-fugitive'
    Plug 'jiangmiao/auto-pairs'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'yonchu/accelerated-smooth-scroll'
    Plug 'bronson/vim-trailing-whitespace'
call plug#end()

" ==================== config section ==================== "
if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

syntax enable                           " Enables syntax highlighing
set background=dark                     " Tell vim what the background color looks like
colorscheme onedark

set undofile                            " Creates files with undo history for any file opened
set undodir=$HOME/.vim/undo             " Set the directory where the undo files are stored
set undolevels=1000                     " Maximum number of changes that can be undone
set undoreload=10000                    " Save the whole buffer for undo when reloading it
set hidden                              " Required to keep multiple buffers open multiple buffers
set encoding=utf-8                      " The encoding displayed
set fileencoding=utf-8                  " The encoding written to file
set relativenumber number               " Relative line numbers
set cursorline                          " Enable highlighting of the current line
set tabstop=2                           " Insert 2 spaces for a tab
set softtabstop=2                       " Number of spaces a tab counts for when making edits
set shiftwidth=2                        " Change the number of spaces inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set smartindent                         " Makes indenting smart
set expandtab                           " Converts tabs to spaces
set showtabline=2                       " Always show tabs
set autoindent                          " Good auto indent
set showmatch                           " Briefly jumps to the other end of a bracket to show match
set clipboard=unnamedplus               " Copy paste between vim and everything else
set mouse=a                             " Enable your mouse
set cmdheight=2                         " More space for displaying messages
set updatetime=300                      " Faster completion
set lazyredraw                          " screen will not be redrawn while executing macros
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the rig
set formatoptions-=cro                  " Stop newline continution of comments
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc

nnoremap <leader><space> :nohlsearch<CR>

" Move vertically by visual line
nnoremap j gj
nnoremap k gk

" Close current buffer and go to next available one
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Open vimrc for edit
nnoremap <leader>vi :e $MYVIMRC<CR>

" Allows you to navigate buffers using [ and ]
nnoremap <leader>[ :bp<CR>
nnoremap <leader>] :bn<CR>

" Save files without auto formatting
nnoremap <leader>w :CocDisable<CR>:w<CR>:CocEnable<CR>

" Better nav for coc autocomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Toggle comments easily
nnoremap <space>/ :Commentary<CR>
vnoremap <space>/ :Commentary<CR>

" Auto source when writing to init.vm. Alternatively you can run :source $MYVIMRC
au! BufWritePost $MYVIMRC source %

" ==================== Airline Config ===================== "
let g:airline#extensions#tabline#enabled = 1
" Just show the filename (no path) in the tab
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='onedark'

" ================== Fuzzy Search Config ================== "
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Buffers<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

" Let fzf user the_silver_searcher as it's default engine
let $FZF_DEFAULT_OPTS='--color --no-reverse'
let $FZF_DEFAULT_COMMAND = 'ag --ignore node_modules -g ""'

" Allows you to search strings within files
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>

" ================ Coc.Nvim Config ================ "
let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-explorer', 'coc-highlight']

" coc-intellisense config
" Use tab for trigger completion with characters ahead and navigate.
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

" Use <cr> to confirm completion
" `<C-g>u` means break undo chain at current position.
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" coc-explorer
let g:coc_explorer_global_presets = {
\   'floating': {
\      'position': 'floating',
\   }
\ }

nmap <space>e :CocCommand explorer<CR>
nmap <space>f :CocCommand explorer --preset floating<CR>

autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" ==================== Newbie Crutches ==================== "
" noremap <Up>    <Nop>
" noremap <Down>  <Nop>
" noremap <Left>  <Nop>
" noremap <Right> <Nop>

" inoremap <Up>    <Nop>
" inoremap <Down>  <Nop>
" inoremap <Left>  <Nop>
" inoremap <Right> <Nop>
