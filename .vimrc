""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Portable Vim Settings
" => Author: Rui Gu
" => Email: rui.gu3@gmail.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Auto Save Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufRead,BufNewFile * let b:start_time=localtime()
"au CursorHold * call UpdateFile()
"au CursorHoldI * call UpdateFile()
" only write if needed and update the start time after the save
function! UpdateFile()
  if &readonly
  else
    if ((localtime() - b:start_time) >= 5)
      update
      let b:start_time=localtime()
    else
      echo "Only " . (localtime() - b:start_time) . " seconds have elapsed so far."
    endif
  endif
endfunction
au BufWritePre * let b:start_time=localtime()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on
filetype indent on
filetype on

set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc

set nocompatible
set noswapfile
set nowb
set nobackup

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Color Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FilterWritePre * if &diff | colorscheme murphy | endif
colorscheme elflord
syntax on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Statusline Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The Status Line need to be put here because the color scheme will overwrite
" the existing scheme
" Always hide the statusline
set laststatus=2
" Format the statusline
hi User1 ctermbg=Black ctermfg=Green   guibg=green guifg=red
set statusline=%1*%F%h%m\ [Time:\ %{strftime(\"%H:%M\")}]\ [Mod\ Time:\ %{strftime(\"%H:%M:%S\",getftime(expand(\"\%\%\")))}]%=\ [%p%%]\ [%l/%L]
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File Type Specific Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufRead,BufNewFile *.go set filetype=go
au BufNewFile,BufRead *, call SetupForDefault()
au BufNewFile,BufRead *.c, call SetupForCLang()
au BufNewFile,BufRead *.cpp, call SetupForCLang()
au BufNewFile,BufRead *.py, call SetupForPython()
au BufNewFile,BufRead *.go, call SetupForGoLang()
au BufNewFile,BufRead *.yaml, call SetupForCLang()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
" => Some part will be overwritten by \"Language Specific Settings\"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ruler 
set incsearch 
set vb t_vb=
set mouse=v
set tabstop=2
set shiftwidth=2
set nowrap
set backspace=indent,eol,start whichwrap+=<,>,[,]
set ai!
set nu!
set showmatch
set autoindent " always set autoindenting on
set foldmethod=syntax
set foldlevel=100
set hlsearch

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language Specific Settings
" => Detect if the current file type is a C-like language
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration for default languages.
function! SetupForDefault()
    " Use 2 spaces for indentation.
    set noexpandtab
    set shiftwidth=2
    set tabstop=2
    set softtabstop=2
endfunction

" Configuration for C-like languages.
function! SetupForCLang()
    " Use 2 spaces for indentation.
    set expandtab!
    set shiftwidth=2
    set tabstop=2
    set softtabstop=2
    call DisplayLineWidthLimitation()
endfunction

" Configuration for Python.
function! SetupForPython()
    " Use 4 spaces for indentation.
    set expandtab!
    set shiftwidth=4
    set tabstop=4
    set softtabstop=4
    call DisplayLineWidthLimitation()
endfunction

" Configuration for Golang.
function! SetupForGoLang()
    " Use 2 spaces for indentation.
    set noexpandtab
    set shiftwidth=2
    set tabstop=2
    set softtabstop=2
    call DisplayLineWidthLimitation()
endfunction

" Display the 80 chars line width limitation
function! DisplayLineWidthLimitation()
    highlight ColorColumn ctermbg=2
    set colorcolumn=80
endfunction
