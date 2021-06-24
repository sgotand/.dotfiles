echom "start importing " . expand('<sfile>:p')
set laststatus=2
if !has('gui_running')
  set t_Co=256
endif
set noshowmode
" TODO: 一定以上の幅があるときに、pwdも表示する

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'mode_map': {'c': 'NORMAL'},
\ }

let g:lightline.active = {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename', 'anzu', 'cocstatus'],
      \           ],
      \   'right': [ [ 'lineinfo' ],
		  \            [ 'percent' ],
		  \            [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \}


let g:lightline.component_function = {
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'cocstatus': 'LightlineCocStatus',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \   'anzu': 'anzu#search_status',
      \   'sign' : 'LightlineCocHover',
\ }

function! LightlineCocStatus()
  let l:s = coc#status()
  if l:s == ''
    return 'OK'
  else
    return l:s
  endif
endfunction

function! LightlineCocHover() abort
  return CocAction("doHover")
endfunction

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction


function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists('*FugitiveHead')
    return FugitiveHead()
  else
    return ''
  endif
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

echom "finish importing " . expand('<sfile>:p')
