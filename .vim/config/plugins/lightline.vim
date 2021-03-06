let g:lightline = {
    \ 'colorscheme': 'seoul256',
    \ 'mode_map': {
    \   'c': 'NORMAL'
    \ },
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'gitbranch', 'filename' ]
    \   ],
    \   'right': [
    \     [ 'lineinfo' ],
    \     [ 'percent' ],
    \     [ 'fileformat', 'fileencoding', 'filetype' ]
    \   ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'LightlineGitBranch',
    \   'filename': 'LightlineFileName',
    \   'fileformat': 'LightlineFileFormat',
    \   'filetype': 'LightlineFileType',
    \   'fileencoding': 'LightlineFileEncoding',
    \   'mode': 'LightlineMode'
    \ },
    \ 'separator': {
    \   'left': '',
    \   'right': ''
    \ },
    \ 'subseparator': {
    \   'left': '',
    \   'right': ''
    \ }
    \ }

let g:lightline.tab = {
    \ 'active': [
    \   'tabnum',
    \   'lightlinetabname',
    \   'lightlinetabmodified'
    \ ],
    \ 'inactive': [
    \   'tabnum',
    \   'lightlinetabname',
    \   'lightlinetabmodified'
    \ ]
    \ }

let g:lightline.tab_component_function = {
    \ 'lightlinetabname': 'LightlineTabName',
    \ 'lightlinetabmodified': 'LightlineTabModified',
    \ 'readonly': 'lightline#tab#readonly',
    \ 'tabnum': 'lightline#tab#tabnum'
    \ }

function! LightlineModified() abort
  try
    if &modified == 1
      return '+'
    else
      return ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineReadOnly() abort
  try
    if &readonly
      return ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineFileName() abort
  return
    \ ('' != LightlineReadOnly() ? LightlineReadOnly() . ' ' : '') .
    \ (&ft == 'ctrlsf' ? '' :
    \  &ft == 'packager' ? '' :
    \  &ft == 'undotree' ? '' :
    \  '' != expand('%:t') ? expand('%:t') : '[No Name]') .
    \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! GitBranch() abort
  if !exists('b:git_branch')
    silent! let b:git_branch = substitute(strtrans(system("git rev-parse --abbrev-ref HEAD 2>/dev/null")),'\^@','','g')
  endif
  return b:git_branch
endfunction

" refresh git branch periodically
augroup gitbranch
  autocmd!
  autocmd BufEnter,BufWritePost,CursorHold,CursorHoldI,FocusGained <buffer>
    \ silent! unlet b:git_branch
augroup END

function! LightlineGitBranch() abort
  try
    let _ = GitBranch()
    return strlen(_) ? ' ' . _ : ''
  catch
  endtry
  return ''
endfunction

function! LightlineFileFormat() abort
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFileType() abort
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileEncoding() abort
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightlineMode() abort
  let fname = expand('%:t')
  return
    \ fname =~ 'NERD_tree' ? 'NERDTree' :
    \ &ft == 'ctrlsf' ? 'CtrlSF' :
    \ &ft == 'packager' ? 'Packager' :
    \ &ft == 'undotree' ? 'UndoTree' :
    \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineTabName(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let _ = expand('#' . buflist[winnr - 1] . ':t')
  return strlen(_) ? _ : '[No Name]'
endfunction

function! LightlineTabModified(n) abort
  let winnr = tabpagewinnr(a:n)
  return
    \ gettabwinvar(a:n, winnr, '&modified') ? '+' :
    \ gettabwinvar(a:n, winnr, '&modifiable') ? '' : '-'
endfunction

" vim: set filetype=vim foldmethod=marker foldlevel=0 nowrap:
