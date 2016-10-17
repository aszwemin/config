:set tabstop=4           " use 4 spaces to represent tab
:set softtabstop=4
:set shiftwidth=4        " number of spaces to use for auto indent
:set autoindent          " copy indent from current line when starting a new line
:set nu
:set ai sw=4
:set hlsearch            " highlight search result
:set ignorecase          " ignore search case
:set smartcase           " unless you use capitals
:set scrolloff=5
:set fileformat=unix
:set tabpagemax=50
:set expandtab
:set mouse=a
:set wildmenu            " visual autocomplete for command menu

" Make searches appear in centre of page
:nnoremap n nzz
:nnoremap N Nzz
:nnoremap * *zz
:nnoremap # #zz
:nnoremap g* g*zz
:nnoremap g# g#zz

" Clear search highlighting with enter
nnoremap <cr> :noh<CR><CR>:<backspace>

" F9 to toggle paste mode
:nnoremap <silent><F9> :set paste!<CR>

execute pathogen#infect()
syntax on
filetype plugin indent on

" vim fugitive bindings
nmap <leader>gs :Gstatus<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>ga :Gwrite<cr>
nmap <leader>gl :Glog<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gb :Gblame<cr>

" NERDTreeTabs
map <C-n> :NERDTreeTabsToggle<CR>
" let g:nerdtree_tabs_open_on_console_startup=1

" CtrlP
" Only search for things under the directory that you opened vim from
let g:ctrlp_working_path_mode = ''
" Ignore temp files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
" Don't index inside node_modules
let g:ctrlp_custom_ignore = 'node_modules'

" Set 80 column text width
set colorcolumn=80
highlight ColorColumn ctermbg=5

:set t_Co=256

if has('gui_running')
    " set colorscheme and font size for gvim
    colorscheme desert
    set guifont=Inconsolata\ 10
else
    " set colorscheme for terminal vim
    colorscheme distinguished
endif

" set syntastic python checker to flake8
let g:syntastic_python_checkers=['flake8', 'pep257', 'python']
let g:syntastic_python_pep257_args='--ignore=D100,D101,D102,D103,D401,D400,D205,D203,D204'
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1

" Function: Open tag under cursor in new tab C-\
" Source:   http://stackoverflow.com/questions/563616/vimctags-tips-and-tricks
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" tmux hacks
" inside screen / tmux
map <Esc>[C <C-Right>
map <Esc>[D <C-Left>
" insert mode
map! <Esc>[C <C-Right>
map! <Esc>[D <C-Left>
" no screen
map <Esc>[1;5D <C-Left>
map <Esc>[1;5C <C-Right>
" insert mode
map! <Esc>[1;5D <C-Left>
map! <Esc>[1;5C <C-Right>
" Switch tabs with Ctrl left and right
nnoremap <C-right> :tabnext<CR>
nnoremap <C-left> :tabprevious<CR>
" insert mode
inoremap <C-right> <Esc>:tabnext<CR>
inoremap <C-left> <Esc>:tabprevious<CR>

" Automatically strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Hack to show status bar
set laststatus=2
" Enable vim-airline plugins
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1

" Toggle Tagbar
nmap <F8> :TagbarToggle<CR>

" Goyo optimisations
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
  if exists('$TMUX') " hide tmux status bar
    silent !tmux set status off
  endif
  :setlocal spell spelllang=en_gb " enable spellchecker
  :set linebreak " break lines
  " allow navigation within softlines
  imap <silent> <Down> <C-o>gj
  imap <silent> <Up> <C-o>gk
  nmap <silent> <Down> gj
  nmap <silent> <Up> gk
  :call AutoCorrect() " load autocorrections
endfunction

function! s:goyo_leave()
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
  if exists('$TMUX') " reenable tmux status bar
    silent !tmux set status on
  endif
  :set nospell " disable spellchecker
  :set linebreak!
  :unmap <Down>
  :unmap <Up>
endfunction

autocmd User GoyoEnter call <SID>goyo_enter()
autocmd User GoyoLeave call <SID>goyo_leave()

" Settings for vim-easytags
:let g:easytags_async = 1
:let g:easytags_auto_highlight = 0
