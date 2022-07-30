set laststatus=2
set noshowmode
set tabstop=2
set shiftwidth=2
set smarttab
set softtabstop=0
set expandtab
set number
set clipboard=unnamedplus
set wildmode=longest,list,full
set wildmenu
set mouse=a
set autowrite
set ttimeoutlen=5

syntax on

:hi Folded ctermbg=none

let mapleader=","

if v:version >= 800
  " stop vim from silently messing with files that it shouldn't
  set nofixendofline

  " better ascii friendly listchars
  set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>

  " i hate automatic folding
  set foldmethod=manual
  set nofoldenable
endif

set ttyfast

" prevents truncated yanks, deletes, etc.
set viminfo='20,<1000,s1000

" more risky, but cleaner
set nobackup
set noswapfile
set nowritebackup

" highlight search hits
set hlsearch
set incsearch
set linebreak

" disable relative line numbers, remove no to sample it
set norelativenumber

" disable spellcapcheck
set spc=

set noshowmatch

" stop complaints about switching buffer with changes
set hidden

" start at last place you were editing
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" command history
set history=100

au FileType yaml set sw=4

" only load plugins if Plug detected
if filereadable(expand("~/.vim/autoload/plug.vim"))

  " github.com/junegunn/vim-plug

  call plug#begin()
  Plug 'itchyny/lightline.vim'
  Plug 'frazrepo/vim-rainbow'
  Plug 'hashivim/vim-terraform'
  Plug 'tpope/vim-surround'
  Plug 'stephpy/vim-yaml'
  Plug 'sheerun/vim-polyglot'
  Plug 'rwxrob/vim-pandoc-syntax-simple'
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  Plug 'tpope/vim-fugitive'
  Plug 'vim-pandoc/vim-pandoc'
  call plug#end()

  " terraform
  let g:terraform_fmt_on_save = 1

  " pandoc
  let g:pandoc#formatting#mode = 'h' " A'
  let g:pandoc#formatting#textwidth = 92

  " golang
  let g:go_fmt_fail_silently = 0
  let g:go_fmt_command = 'goimports'
  let g:go_fmt_autosave = 1
  let g:go_gopls_enabled = 1
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_variable_declarations = 1
  let g:go_highlight_variable_assignments = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_diagnostic_errors = 1
  let g:go_highlight_diagnostic_warnings = 1
  let g:go_auto_sameids = 0

  let g:lightline = {
    \ 'colorscheme': 'one',
  \}
endif


if (has("termguicolors"))
  set termguicolors
endif

if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
  augroup END
endif

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

colorscheme onedark

" better use of arrow keys, number increment/decrement
nnoremap <up> <C-a>
nnoremap <down> <C-x>


" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Enable and disable auto comment
map <leader>c :setlocal formatoptions-=cro<CR>
map <leader>C :setlocal formatoptions=cro<CR>

" Enable spell checking, s for spell check
map <leader>s :setlocal spell! spelllang=en_gb<CR>

nnoremap S :%s//GI<Left><Left><Left>
