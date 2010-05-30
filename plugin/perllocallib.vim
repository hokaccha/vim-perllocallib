" perllocallib.vim - description
"
" Author:  Kazuhito Hokamura <http://webtech-walker.com/>
" Version: 0.0.1
" License: MIT License <http://www.opensource.org/licenses/mit-license.php>

if exists('g:loaded_perllocallib')
  finish
endif
let g:loaded_perllocallib = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? -complete=file Locallib call perllocallib#set(<q-args>)

let &cpo = s:save_cpo


" __END__
" vim:tw=78:sts=2:sw=2:ts=2:fdm=marker:
