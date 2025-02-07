set encoding=utf8
scriptencoding utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ⡀⢀ ⠄ ⣀⣀  ⡀⣀ ⢀⣀
" ⠱⠃ ⠇ ⠇⠇⠇ ⠏  ⠣⠤
"

"Plugins {{{

" vimkubectl
set rtp+=~/code/vim/vimkubectl

" % jump to matching xml tags, if/else/endif, etc.
packadd! matchit

" Sensible defaults (loads $VIMRUNTIME/defaults.vim )
"runtime! defaults.vim

let g:vim_markdown_folding_disabled = 1     " Disable vim-markdown folds by default
let g:vim_markdown_frontmatter = 1          " Highlight YAML front matter
let g:vim_markdown_conceal = 1
let g:vim_markdown_conceal_code_blocks = 1

" }}}

"Appearance {{{

" Enable 24-bit RGB color
if (has('termguicolors'))
  set termguicolors
endif

" Set and configure the color scheme
syntax enable           " enable syntax highlighting
colorscheme habamax
" Highlight embedded lua in .vim
let g:vimsyn_embed = 'l'
" Transparent background
"autocmd vimenter * hi! Normal ctermbg=NONE guibg=NONE
"autocmd vimenter * hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

set background=dark
set number              " Show line numbers
set relativenumber      " Relative line numbering
set showcmd             " Display partially typed command
set lazyredraw          " Do not redraw on macro/regs/untyped commands
set showmatch           " Highlight matching [{()}]
set hlsearch            " Highlight search matches
set scrolloff=0         " Scroll offset
set conceallevel=2      " Enable text conceal (for vim-markdown)
set concealcursor=nc    " Text is not concealed when in insert mode
set colorcolumn=80      " Show column at 80 chars
set guifont=Hack:h12

" Disable all error bells
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Make active buffer more obvious
augroup BufFocus
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

" {{{ Transparency

"hi Normal ctermbg=NONE 
"fun! AdaptColorscheme()
"  highlight clear CursorLine
"  highlight Normal ctermbg=none
"  highlight LineNr ctermbg=none
"  highlight Folded ctermbg=none
"  highlight NonText ctermbg=none
"  highlight SpecialKey ctermbg=none
"  highlight VertSplit ctermbg=none
"  highlight SignColumn ctermbg=none
"endfun
"autocmd ColorScheme * call AdaptColorscheme()
"
"hi Normal guibg=NONE ctermbg=NONE
"hi CursorColumn cterm=NONE ctermbg=NONE ctermfg=NONE
"hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE
"hi CursorLineNr cterm=NONE ctermbg=NONE ctermfg=NONE
"hi clear SignColumn
"highlight cursorline ctermbg=none
"highlight cursorlineNR ctermbg=none
"highlight clear LineNr
"highlight clear SignColumn
"
"set cursorline
"set noshowmode
"" Enable CursorLine
"set nocursorline
"" Default Colors for CursorLine
"hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE
"
"" Change Color when entering Insert Mode
"autocmd InsertEnter * set nocursorline
"
"" Revert Color to default when leaving Insert Mode
"autocmd InsertLeave * set nocursorline

" }}}

" }}}

"Behavior {{{

filetype plugin indent on " Load filetype-specific configuration
set tabstop=4             " show existing tab with 4 spaces width
set shiftwidth=4          " when indenting with '>', use 4 spaces width
set expandtab             " On pressing tab, insert 4 spaces
set modeline              " Read vim modeline configs
" Swap files directory
set directory=$HOME/.vim/swapfiles//
set backupdir=$HOME/.vim/swapfiles//

set nrformats=bin,hex   " define bases for <C-a> and <C-x> math operations
set history=1000        " Remember more stuff
set tabpagemax=50       " Max tab pages

" Backspace works on autoindent, line break and start of insert
set backspace=indent,eol,start
set autoindent
set wrap

set ffs=unix,dos,mac    " Standard file type as Unix
set autoread            " automatically read when file is changed from outside
set hidden              " Hide unsaved buffers instead of closing
"set confirm             " Prompt if exiting without saving
set mouse=a             " Use mouse for all modes
set regexpengine=0      " Explicitly disable old regex engine

set wildmenu            " Completion dropdown-thing
set wildoptions=pum     " Show completion inside a pop up menu
set wildmode=full
" Ignore these files when using tab completion
set wildignore+=.javac,node_modules,*.pyc
set wildignore+=.o,.obj,.dll,.exe,.git,.orig
" Add extension when opening paths with gf
set suffixesadd=.rs,.js,.ts

set incsearch           " Search as characters are entered
set ignorecase          " Ignore case
set smartcase           " Except if there is a capital letter
if has('nvim')
  set inccommand=split   " Show preview in split
endif

set splitbelow          " New split goes below
set splitright          " and to right
set foldenable          " Enable code folding
set foldnestmax=10      " Max 10 nested folds
set foldlevel=99         " Do not close folds by default
set formatoptions+=j    " Delete comment character when joining commented lines
set shortmess+=c        " Do not pass messages to ins-completion-menu

if has('nvim')
  " Avoid performing second stage diffs on large hunks
  set diffopt+=linematch:60
endif

" Turn some operations into multiple edits
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
"inoremap <CR> <C-G>u<CR>
"inoremap . <C-G>u.
"inoremap ? <C-G>u?
"inoremap , <C-G>u,

" :h :mkview
set sessionoptions-=options
set viewoptions-=options

fun! FoldText()
  let line = getline(v:foldstart)
  let line = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')  " }}}

  let offset = 16
  let space = repeat(' ', winwidth(0) - strdisplaywidth(line) - offset) 
  let lines = v:foldend-v:foldstart + 1

  return line . space . lines
endfun
set foldtext=FoldText()

" Use ripgrep when available
if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" For vim-sandwitch to work reliably
nmap s <Nop>
xmap s <Nop>

" }}}

"Autocmds {{{

augroup filetype_settings
  au!
  " set filetypes as typescriptreact, for vim-jsx-typescript
  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

  " GLSL
  autocmd BufNewFile,BufRead *.glslx
        \ set ft=glsl

  " Kernel device tree files
  autocmd BufNewFile,BufRead *.overlay
        \ set ft=dts

  " Encrypted files, disable all backups
  autocmd BufReadPre,FileReadPre *.gpg,*.asc set viminfo= noswapfile noundofile nobackup

  " JS/TS
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact,javascript.jsx,typescript.tsx,svelte
        \ exec 'command! -buffer Fmt Neoformat prettier' |
        \ exec 'inoreabbrev <buffer> clg console.log()<LEFT>'

  " Web
  autocmd FileType json,yaml,css,scss
        \ exec 'command! -buffer Fmt Neoformat prettier'

  " Lua
  autocmd FileType lua
        \ exec 'command! -buffer Fmt Neoformat stylua'

  " markdown
  " Note: Slack hates the text/html type, routing it through firefox for now
  autocmd FileType markdown
        \ exec 'command! -buffer -range=% HTMLOpen silent w !pandoc -f markdown -t html > /tmp/firemd.html; firefox /tmp/firemd.html' |
        \ exec 'command! -buffer -range=% HTMLCopy silent w !pandoc -f markdown -t html | xclip -sel c -t text/html'

  " Lua
  autocmd Filetype lua
        \ setlocal expandtab tabstop=4 shiftwidth=4

augroup END

augroup quickfix_settings
  au!
  " Open quickfix window if getexpr is run
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

" }}}

"Status line {{{

" 
set laststatus=3                " Always show statusline

let currentmode = {
      \ 'n'  : '  NRM ',
      \ 'i'  : '  INS ',
      \ 'v'  : '  VIS ',
      \ 'V'  : '  V·LN ',
      \ '' : '  V·BLK ',
      \ 'Rv' : '  V·RPLCE ',
      \ 'R'  : '  RPLCE ',
      \ 'no' : '  NRM·OP ',
      \ 's'  : '  SEL ',
      \ 'S'  : '  S·LN ',
      \ '^S' : '  S·BLK ',
      \ 'c'  : '  CMD ',
      \ 'r'  : '  PRMPT ',
      \ 'rm' : '  MORE ',
      \ 'r?' : '  CNFRM ',
      \ 'cv' : '  VIM·EX ',
      \ 'ce' : '  EX ',
      \ '!'  : '  SHL ',
      \ 't'  : '  TERM ',
      \}

" |hitest.vim|

set statusline=
set statusline+=%#DiffAdd#%{currentmode[mode()]}

set statusline+=%#Cursor#
set statusline+=\ %n\             " buffer number
set statusline+=%{&paste?'\ PASTE\ ':''}
set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%R                " readonly flag
set statusline+=%M                " modified [+] flag
set statusline+=%#CursorLine#     " separator
set statusline+=\ %{ShortFile()}  " file name
set statusline+=%=                " right align

set statusline+=\ %Y\ \          " file type
set statusline+=%#Folded#         " color
if has('nvim')
  set statusline+=%{FugitiveHead()}
endif
set statusline+=%#CursorLine#     " color
set statusline+=\ %3l:%-2c        " line + column
set statusline+=%#Cursor#         " color
set statusline+=%3p%%\            " percentage

" }}}

"netrw {{{

" override netrw with fern
nnoremap - :Fern . -reveal=%<CR>
"let g:netrw_banner = 0          " Top banner
"let g:netrw_liststyle = 3       " Directory list view
"let g:netrw_browse_split = 0    " File open behaviour
"let g:netrw_preview = 1         " Open preview files vertically
"let g:netrw_altv = 1
"let g:netrw_winsize = 17        " Size of opened buffer

" }}}

"Utils {{{

" Runs callback with visually selected text as string argument
fun! s:withSelection(callback)
  let temp = @@
  norm! gvy
  call a:callback(@@)
  let @@ = temp
endfun

" Shortened file path
fun! ShortFile()
  return pathshorten(fnamemodify(expand('%:p'), ':~:.'))
endfun

" Shortened CWD path
fun! ShortPath()
  let short = pathshorten(fnamemodify(getcwd(), ':~:.'))
  return empty(short) ? '~/' : short . (short =~ '/$' ? '' : '/')
endfun

" }}}

"Key maps {{{

" Start all searches in very magic mode
nnoremap / /\v

let mapleader = ' '             " Leader key
let maplocalleader = ';'        " Local leader key

" Search for selected content
fun! s:VSetSearch(text)
  let @/ = '\V' . substitute(escape(a:text, '\'), '\n', '\\n', 'g')
endfun
vnoremap * :<C-u>call <SID>withSelection(function('<SID>VSetSearch'))<CR>//<CR>
vnoremap # :<C-u>call <SID>withSelection(function('<SID>VSetSearch'))<CR>??<CR>

" Yank to clipboard
if has('mac')
  nnoremap <leader>y :call system("pbcopy", @")<CR>
else
  nnoremap <leader>y :call system("wl-copy", @")<CR>
endif

" Map redraw-screen to also clear search highlights
nnoremap <silent> <C-L> :nohl<CR>:mat<CR><C-L>

" Quickly edit and reload vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
"nnoremap <leader>sv :source $MYVIMRC<CR>

" Highlight trailing whitespace
nnoremap <leader>w :match Error /\v\s+$/<CR>

" Write if there are unsaved changes
nnoremap <leader>u :update<CR>

" Quit
nnoremap <leader>q :q<CR>

" Navigate panes
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>l :wincmd l<CR>

" Navigate quickfix list
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [<C-Q> :cpfile<CR>
nnoremap ]<C-Q> :cnfile<CR>

" Navigate buffer list
nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :brewind<CR>

" Navigate arglist
nnoremap <LocalLeader>1 :1argument<CR>
nnoremap <LocalLeader>2 :2argument<CR>
nnoremap <LocalLeader>3 :3argument<CR>
nnoremap <LocalLeader>4 :4argument<CR>
" Add current file to arglist
nnoremap <silent> <LocalLeader>a :argadd<CR>:argdedupe<CR>
" Show arglist
nnoremap <LocalLeader>r :args<CR>
" Remove current file from arglist
nnoremap <LocalLeader>d :argdelete<CR>

" Open "fast" buffer switcher
nnoremap <LocalLeader>b :ls<CR>:b 

" Grep for word under cursor in cwd and open matched files in quickfix window
"nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<CR>:copen<CR>

" }}}

"Commands {{{

" Save file with elevated permissions
command! W w !sudo tee % > /dev/null

" cd to directory of current file
command! Fcd silent! lcd %:p:h

" Open 4-pane conflict resolution diff
command! Mergetool Ghdiffsplit | Gvdiffsplit!

" :Move rename/move current buffer
fun! s:move_file(new_file_path)
  execute 'saveas ' . a:new_file_path
  call delete(expand('#:p'))
  bd #
endfun

command! -nargs=1 -complete=file Move call <SID>move_file(<f-args>)

" Close buffer without messing up splits
command! Bd bp|bd #

" Grep raw output for use with cgetexpr
" https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
fun! Grep(...)
  return system(join([&grepprg] + [join(a:000, ' ')], ' '))
endfun

command! -nargs=+ -complete=file_in_path Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path LGrep lgetexpr Grep(<f-args>)

" :grep is :Grep
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

fun! EncryptFile()
  exec '%!gpg --default-recipient-self --armor --encrypt 2> /dev/null'
  setlocal bin
  setlocal ch=2
endfun

fun! DecryptFile()
  exec '%!gpg --decrypt 2> /dev/null'
  setlocal nobin
  setlocal ch=1
endfun

command! Decrypt call DecryptFile()
command! Encrypt call EncryptFile()

" }}}

"Plugin configs {{{

" Vimkubectl configuration
" ----------

let g:vimkubectl_command = 'oc'

" FZF configuration
" ----------

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7 } }
"let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

" Starter command for bat
let BAT_CMD = 'bat --style=plain --color=always'

" Only display the first x lines
let BAT_CMD_TRUNC = BAT_CMD . ' --line-range :500'
let BASIC_PREVIEW = '--preview "' . BAT_CMD_TRUNC . ' {}"'

let EXPECT_BIND = '--expect=ctrl-t,ctrl-v,ctrl-s,ctrl-b,ctrl-q'
let BUFLINE_PREVIEW = '--delimiter \"
      \ --preview "' . BAT_CMD_TRUNC . ' {2}"'

" List open buffers
fun! s:buflist()
  redir => ls
  silent ls
  redir END

  " Pass buffer line number for previewing in bat
  "let result = []
  "for buf in split(ls, '\n')
  "  let bufnum = s:bufnumber(buf)
  "  let path = matchlist(buf, '\v"(.*)"')[1]
  "  let lineno = matchlist(buf, '\v([0-9]*)$')[1] + 0
  "  let fulpath = bufname(bufnum + 0)
  "  " Use relative path with "../.."
  "  " Doesn't work currently...
  "  " let relpath = system(printf('realpath --relative-to="${PWD}" "%s"', fulpath))
  "  call add(result, printf('%s "%s" %s', bufnum, fulpath, lineno))
  "endfor

  return split(ls, '\n')
endfun

" Get bufno from bufline
fun! s:bufnumber(bufline)
  return matchlist(a:bufline, '\v^ *([0-9]*)')[1]
endfun

" Add files to quickfix list and open it
fun! s:build_qflist(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfun

" Manage buffers
fun! s:bufmanage(result)
  if len(a:result) < 2
    return
  endif

  let cmd = get({'ctrl-s': 'sbuffer',
        \ 'ctrl-v': 'vert sbuffer',
        \ 'ctrl-t': 'tabnew | buffer',
        \ 'ctrl-b': 'bdelete',
        \ 'ctrl-q': function('s:build_qflist')},
        \ a:result[0], 'buffer')
  let buffers = a:result[1:]

  for each in buffers
    execute cmd s:bufnumber(each)
  endfor
endfun

" Move to dir
fun! s:navigate(dir)
  if len(a:dir) == 0
    return
  endif
  execute 'cd ' . a:dir
  echo a:dir
endfun

" Open file(s) from ripgrep result line
fun! OpenFilesAtLocation(result)
  if len(a:result) < 2
    return
  endif

  let cmd = get({
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit',
        \ 'ctrl-t': 'tabedit',
        \ 'ctrl-q': function('s:build_qflist')},
        \ a:result[0], 'edit',
        \ )
  let buffers = a:result[1:]

  for each in buffers
    let filePos = split(each, ':')
    echom 'cmd: ' cmd . ' +' . l:filePos[1] . ' ' . l:filePos[0]
    exec cmd . ' +' . l:filePos[1] . ' ' . l:filePos[0]
  endfor
endfun

fun! s:FuzzyRgBackend(initialQuery)
  " VimL can't do var scopes smh... :/
  let l:BAT_CMD = 'bat --style=plain --color=always'
  let l:RG_PREVIEW = '--delimiter
        \ : --preview "' . l:BAT_CMD . ' {1} --highlight-line {2}"
        \ --preview-window "+{2}/2"'
  call fzf#run(fzf#wrap({
        \ 'sink*': function('OpenFilesAtLocation'),
        \ 'options': join([
          \ '--disabled',
          \ '--ansi',
          \ '--bind "ctrl-r:reload:rg -i --line-number {q} || true"',
          \ '--query "' . a:initialQuery . '"',
          \ '--header="Run search with CTRL+r"',
          \ '--expect=ctrl-t,ctrl-v,ctrl-s',
          \ l:RG_PREVIEW,
        \ ], ' ')}))
endfun

" Open files
nnoremap <silent> <Leader>f :call fzf#run(fzf#wrap({
      \   'source':  'fd --type f',
      \   'options': join([EXPECT_BIND, BASIC_PREVIEW], ' '),
      \ }))<CR>

" Manage buffers
nnoremap <silent> <Leader>b :call fzf#run(fzf#wrap({
      \   'source':  reverse(<sid>buflist()),
      \   'sink*':   function('<sid>bufmanage'),
      \   'options': join([EXPECT_BIND, BUFLINE_PREVIEW], ' '),
      \ }))<CR>

" Directory selection
nnoremap <silent> <Leader>F :call fzf#run(fzf#wrap({
      \   'source': 'fd --type d',
      \   'sink':   function('<sid>navigate'),
      \   'options': '+m',
      \ }))<CR>

" Use fzf as frontend for ripgrep
nnoremap <silent> <Leader>s :call <SID>FuzzyRgBackend('')<CR>
vnoremap <silent> <Leader>s :call <SID>withSelection(function('<SID>FuzzyRgBackend'))<CR>

" Fern config
" ----------

" Custom symbols
" these cause syntax highlighting to break
"let g:fern#renderer#default#leaf_symbol =      "├─ "
let g:fern#renderer#default#leaf_symbol =      "   "
let g:fern#renderer#default#root_symbol =      "┬ "
let g:fern#renderer#default#leading =          "│"
let g:fern#renderer#default#expanded_symbol =  "├┬ "
let g:fern#renderer#default#collapsed_symbol = "├─ "

" Disable all default mappings and define them manually
let g:fern#disable_default_mappings = 1

fun! s:init_fern() abort
  nnoremap  <buffer>  q      :bd<CR>
  nmap      <buffer>  h      <Plug>(fern-action-collapse)
  nmap      <buffer>  l      <Plug>(fern-action-open-or-expand)
  nmap      <buffer>  .g     <Plug>(fern-action-hidden:toggle)
  nmap      <buffer>  <C-H>  <Plug>(fern-action-leave)
  nmap      <buffer>  <C-L>  <Plug>(fern-action-redraw)
  nmap      <buffer>  <CR>   <Plug>(fern-action-open-or-enter)
  nmap      <buffer>  t      <Plug>(fern-action-terminal)
  nmap      <buffer>  y      <Plug>(fern-action-yank)
  nmap      <buffer>  Z      <Plug>(fern-action-zoom)
endfun

augroup my-fern
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

" Indent guides
" ----------

let g:indentguides_ignorelist = [ 'text', 'help', 'fern', 'fugitive' ]
let g:indentguides_toggleListMode = 0
let g:indentguides_spacechar = '│'
let g:indentguides_tabchar =   '⋅'

" Neoformat
" ----------
" Try using binaries from node_modules
let g:neoformat_try_node_exe = 1

" }}}

" vim: fdm=marker:fdl=0:et:sw=2:
