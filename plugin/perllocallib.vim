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

" plugin code here

let &cpo = s:save_cpo
