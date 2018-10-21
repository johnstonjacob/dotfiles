let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif
set nocompatible

filetype off
syntax on

let mapleader=','

" use system clipboard
set clipboard=unnamed

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set backspace=2


" save files opened in readonly mode
cmap w!! w !sudo tee %

set number ruler

" only case sensitive if a capital letter is used
set ignorecase smartcase
set autoread

" use tmp folder for swp files
set directory^=$HOME/.vim/tmp//

" plugin manager and fuzzy file searching
set rtp+=/usr/local/opt/fzf

let g:go_fmt_command = "goimports"
let g:syntastic_yaml_checkers = ['yamllint']

call plug#begin('~/.config/nvim/plugged')

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" use <C-hjkl> for movement between vim and tmux
Plug 'christoomey/vim-tmux-navigator'

Plug 'Shougo/denite.nvim'

Plug 'fatih/vim-go'

Plug 'scrooloose/nerdtree'

Plug 'crusoexia/vim-monokai'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'kaicataldo/material.vim'

" js
Plug 'https://github.com/crusoexia/vim-javascript-lib'
Plug 'gavocanov/vim-js-indent'
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'prettier/vim-prettier'
Plug 'posva/vim-vue'

Plug 'w0rp/ale'

Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

Plug 'jiangmiao/auto-pairs'

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugsins'  }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'chr4/nginx.vim'

call plug#end()

filetype plugin indent on

" Visuals
if has('termguicolors')
    set termguicolors " True colors
else
    set t_Co=256
endif

" material theme settings
let g:material_theme_style = 'palenight'
let g:material_terminal_italics = 1

" set color scheme
set background=dark
colorscheme material 

au BufNewFile,BufRead *.vue setf vue

map <C-n> :NERDTreeToggle<CR>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

nmap <leader>t :Denite file_rec<CR>
map <leader>h :%s///<left><left>
nmap <silent> <leader>/ :nohlsearch<CR>

" tab complete and cycle 
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

try
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'auto_resize': 1,
\ 'prompt': 'λ:',
\ 'direction': 'rightbelow',
\ 'winminheight': '10',
\ 'highlight_mode_insert': 'Visual',
\ 'highlight_mode_normal': 'Visual',
\ 'prompt_highlight': 'Function',
\ 'highlight_matched_char': 'Function',
\ 'highlight_matched_range': 'Normal'
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry

" disable auto comment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
