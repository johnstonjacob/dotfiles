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

set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
set backspace=2

" remove EOL whitespace
" autocmd BufWritePre * %s/\s\+$//e

" add yaml stuff
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
set indentkeys-=0#

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

call plug#begin('~/.config/nvim/plugged')

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" python venv
"let g:python_host_prog="/usr/bin/python"
"let g:python3_host_prog = '/Users/jjohnston/Documents/dev/venv/py3nvim/bin/python'

Plug 'dannyob/quickfixstatus'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'jvirtanen/vim-hcl'

" writing
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'dbmrq/vim-ditto'

" Use autocmds to check your text automatically and keep the highlighting
" up to date (easier):
au FileType markdown,text,tex DittoOn  " Turn on Ditto's autocmds
nmap <leader>di <Plug>ToggleDitto      " Turn Ditto on and off

" If you don't want the autocmds, you can also use an operator to check
" specific parts of your text:
" vmap <leader>d <Plug>Ditto	       " Call Ditto on visual selection
" nmap <leader>d <Plug>Ditto	       " Call Ditto on operator movement

nmap =d <Plug>DittoNext                " Jump to the next word
nmap -d <Plug>DittoPrev                " Jump to the previous word
nmap +d <Plug>DittoGood                " Ignore the word under the cursor
nmap _d <Plug>DittoBad                 " Stop ignoring the word under the cursor
nmap ]d <Plug>DittoMore                " Show the next matches
nmap [d <Plug>DittoLess                " Show the previous matches

function Writing()
    echom "Write stuff"
    execute "Goyo"
    execute "ALEDisable"
    execute "Limelight"
    execute "NoDitto"
endfunction

function StopWriting()
    execute "Goyo"
    execute "ALEEnable"
    execute "Limelight!"
    execute "Ditto"
endfunction

let g:writing = 0

function! ToggleWriting()
    if g:writing
        call StopWriting()
        let g:writing = 0
    else
        call Writing()
        let g:writing = 1
    endif
endfunction

nmap <C-y> :call ToggleWriting() <cr>

" use <C-hjkl> for movement between vim and tmux
Plug 'christoomey/vim-tmux-navigator'

Plug 'Shougo/denite.nvim'

Plug 'numirias/semshi'
"Plug 'psf/black'
"Plug 'psf/black', { 'tag': '19.10b0' }

Plug 'fatih/vim-go'

Plug 'mrk21/yaml-vim'

Plug 'tpope/vim-surround'

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

Plug 'reedes/vim-litecorrect'

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
let g:go_fmt_command = "goimports"

Plug 'chr4/nginx.vim'
Plug 'hashivim/vim-terraform'

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
call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

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

call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

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
