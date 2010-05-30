" perllocallib.vim - description
"
" Author:  Kazuhito Hokamura <http://webtech-walker.com/>
" Version: 0.0.1
" License: MIT License <http://www.opensource.org/licenses/mit-license.php>

function! perllocallib#set(install_base)
  if s:is_install_local_lib() == 0
    call s:error('not installed local::lib')
    return
  endif

  let old_install_base = s:get_old_install_base()

  if a:install_base == ''
    echo old_install_base == '' ? 'none' : old_install_base
    return
  endif

  let install_base = fnamemodify(a:install_base, ':p')
  if !isdirectory(install_base)
    call s:error('no such directory')
    return
  endif

  if install_base ==# old_install_base
    echo 'already setting it.'
    return
  endif

  call s:remove_old_env(old_install_base)
  call s:set_new_env(install_base)
endfunction

function! s:is_install_local_lib()
  return system('perl -e ''
  \ eval { require local::lib };
  \ print $@ ? 0 : 1;
  \''')
endfunction

function! s:get_old_install_base()
  let mm_opt = {}
  let old_install_base = ''
  for opt in split($PERL_MM_OPT, ':\+')
    let [k, v] = split(opt, '=')
    let mm_opt[k] = v
  endfor
  if exists('mm_opt.INSTALL_BASE')
    let old_install_base = mm_opt.INSTALL_BASE
  endif

  return old_install_base
endfunction

function! s:remove_old_env(install_base)
  let old_env = s:get_local_lib_env(a:install_base)
  let $PATH = s:remove_path($PATH, old_env.path)
  for perl5lib in old_env.perl5libs
    let $PERL5LIB = s:remove_path($PERL5LIB, perl5lib)
  endfor
endfunction

function! s:set_new_env(install_base)
    let env = s:get_local_lib_env(a:install_base)
    let $PERL_MM_OPT = s:insert_path($PERL_MM_OPT, env.perl_mm_opt)
    let $PATH = s:insert_path($PATH, env.path)
    for perl5lib in env.perl5libs
        let $PERL5LIB = s:insert_path($PERL5LIB, perl5lib)
    endfor
endfunction

function! s:get_local_lib_env(path)
  let res = system('perl -Mlocal::lib='.a:path)

  let envs = split(res, '\n')
  let ret = {}

  let match = matchlist(envs, '\vPERL5LIB\="(.{-})(:\$PERL5LIB)?"')
  if exists('match[1]')
    let ret.perl5libs = split(match[1], ':')
  endif

  let match = matchlist(envs, '\vPATH\="(.{-})(:\$PATH)?"')
  if exists('match[1]')
    let ret.path = match[1]
  endif

  let match = matchlist(envs, '\vPERL_MM_OPT\="(.{-})"')
  if exists('match[1]')
    let ret.perl_mm_opt = match[1]
  endif

  return ret
endfunction

function! s:remove_path(base_path, remove_path)
  let paths = split(a:base_path, ':\+')
  let remove_path = substitute(a:remove_path, '\v(.{-})/+$', '\1', '')
  let index = match(paths, '^'.remove_path.'\?$')
  if index != -1
    call remove(paths, index)
  endif
  return join(paths, ':')
endfunction

function! s:insert_path(base_path, insert_path)
  let paths = split(s:remove_path(a:base_path, a:insert_path), ':\+')
  call insert(paths, a:insert_path)
  return join(paths, ':')
endfunction

function! s:error(msg)
  echohl ErrorMsg
  echo a:msg
  echohl None
endfunction


" __END__
" vim:tw=78:sts=2:sw=2:ts=2:fdm=marker:
