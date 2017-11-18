" *** General
au FileType go setlocal noexpandtab
au FileType go setlocal ts=3
au FileType go setlocal sw=3
let g:indent_guides_enable_on_vim_startup = 0
" :IndentGuidesDisable

" vim-go
let g:go_snippet_engine = "ultisnips"
let g:go_disable_autoinstall = 0

func! GoFmtImap()
  let lines_before = line('$')
  let cur_pos = getpos('.')
  :GoFmt
  let lines_after = line('$')
  let line_diff = max([0,cur_pos[1] + lines_after - lines_before])
  let cur_pos[1] = line_diff
  call setpos('.', cur_pos)
endfunc

func! GoImportImap()
  let lines_before = line('$')
  let cur_pos = getpos('.')
  let pkg = input('GoImport ')
  execute ':GoImport ' . pkg
  let lines_after = line('$')
  let line_diff = max([0,cur_pos[1] + lines_after - lines_before])
  let cur_pos[1] = line_diff
  call setpos('.', cur_pos)
endfunc

au FileType go imap <C-A-i> <C-\><C-O>call GoImportImap()
" au FileType go nmap <C-A-f> <Plug>(go-format)
au FileType go nmap <Leader>gd <Plug>(go-doc-split)
au FileType go nnoremap <leader>m :silent make\|redraw!\|botright cwindow\|cc<CR>

au BufEnter,FileType go :TagbarOpen

" ***
" GoDef
au FileType go let g:godef_same_file_in_same_window = 1
" ***

" ***
" tag bar
au FileType go let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
" ***

" ***
" GoDoc
function! FixWindows()
  let cur_win = winnr()
  let cur_cur = getcurpos()
  call tagbar#CloseWindow()
  exec "wincmd ="
  call tagbar#OpenWindow()
  let qf = []
  let pw = []
  let godoc = []
  for i in range(1,winnr('$'))
    if getbufvar(winbufnr(i), '&filetype') == "godoc"
      call insert(godoc,i)
    endif
    if getwinvar(i, '&previewwindow')
      call insert(pw,i)
    endif
    if getbufvar(winbufnr(i), '&filetype') == "qf"
      call insert(qf,i)
    endif
  endfor
  for i in qf
    exec i."wincmd w"
    " wincmd J
    call AdjustWindowHeight(3,10)
    setlocal winheight=3
    setlocal winminheight=3
    call AdjustWindowHeight(3,10)
  endfor
  for i in godoc
    exec i."wincmd w"
    call AdjustWindowHeight(10,10)
  endfor
  for i in pw
    exec i."wincmd w"
    call AdjustWindowHeight(3,10)
    setlocal winheight=3
    setlocal winminheight=3
    call AdjustWindowHeight(3,10)
  endfor
  exec cur_win."wincmd w"
  call setpos(".", cur_cur)
endfunc

nmap <C-g> :silent call FixWindows()<CR>
au FileType godoc resize 10

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

" autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow
