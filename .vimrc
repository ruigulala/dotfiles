""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Portable Vim Settings
" => Author: Rui Gu
" => Email: rui.gu3@gmail.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufRead,BufNewFile *.go set filetype=go

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
colorscheme elflord
syntax on
highlight ColorColumn ctermbg=2
set colorcolumn=100

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

set ruler 
set incsearch 
set vb t_vb=
set mouse=v "允许鼠标的使用

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=2
set shiftwidth=2
set expandtab
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
" => File Type Specific Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.c, call SetupForCLang()
au BufNewFile,BufRead *.cpp, call SetupForCLang()
au BufNewFile,BufRead *.py, call SetupForCLang()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Google Stuff
" => Detect if the current file type is a C-like language
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration for C-like languages.
function! SetupForCLang()
    " Use 2 spaces for indentation.
    setlocal shiftwidth=2
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal expandtab

    " Configure auto-indentation formatting.
    setlocal cindent
    setlocal cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4
    setlocal indentexpr=GoogleCppIndent()
    let b:undo_indent = "setl sw< ts< sts< et< tw< wrap< cin< cino< inde<"
endfunction

" Configuration for Python.
function! SetupForPython()
    " Use 4 spaces for indentation.
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal expandtab

    " Configure auto-indentation formatting.
    setlocal cindent
    setlocal cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4
    setlocal indentexpr=GoogleCppIndent()
    let b:undo_indent = "setl sw< ts< sts< et< tw< wrap< cin< cino< inde<"
endfunction

" From https://github.com/vim-scripts/google.vim/blob/master/indent/google.vim
function! GoogleCppIndent()
    let l:cline_num = line('.')

    let l:orig_indent = cindent(l:cline_num)

    if l:orig_indent == 0 | return 0 | endif

    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    if l:pline =~# '^\s*template' | return l:pline_indent | endif

    " TODO: I don't know to correct it:
    " namespace test {
    " void
    " ....<-- invalid cindent pos
    "
    " void test() {
    " }
    "
    " void
    " <-- cindent pos
    if l:orig_indent != &shiftwidth | return l:orig_indent | endif

    let l:in_comment = 0
    let l:pline_num = prevnonblank(l:cline_num - 1)
    while l:pline_num > -1
        let l:pline = getline(l:pline_num)
        let l:pline_indent = indent(l:pline_num)

        if l:in_comment == 0 && l:pline =~ '^.\{-}\(/\*.\{-}\)\@<!\*/'
            let l:in_comment = 1
        elseif l:in_comment == 1
            if l:pline =~ '/\*\(.\{-}\*/\)\@!'
                let l:in_comment = 0
            endif
        elseif l:pline_indent == 0
            if l:pline !~# '\(#define\)\|\(^\s*//\)\|\(^\s*{\)'
                if l:pline =~# '^\s*namespace.*'
                    return 0
                else
                    return l:orig_indent
                endif
            elseif l:pline =~# '\\$'
                return l:orig_indent
            endif
        else
            return l:orig_indent
        endif

        let l:pline_num = prevnonblank(l:pline_num - 1)
    endwhile

    return l:orig_indent
endfunction
""""""""""""""""""""""""""""
