"======================================================================
"
" keysound.vim - 
"
" Created by skywind on 2018/05/01
" Last Modified: 2018/05/01 18:20:28
"
"======================================================================


"----------------------------------------------------------------------
" global settings
"----------------------------------------------------------------------
if !exists('g:keysound_py_version')
	let g:keysound_py_version = 0
endif

if !exists('g:keysound_theme')
	let g:keysound_theme = 'typewriter'
endif


"----------------------------------------------------------------------
" tools
"----------------------------------------------------------------------
function! keysound#errmsg(msg)
	redraw | echo '' | redraw
	echohl ErrorMsg
	echom a:msg
	echohl NONE
endfunc


"----------------------------------------------------------------------
" python init 
"----------------------------------------------------------------------
let s:scripthome = expand('<sfile>:p:h')
let s:py_cmd = ''
let s:py_eval = ''
let s:py_version = 0

if g:keysound_py_version == 0
	if has('python')
		let s:py_cmd = 'py'
		let s:py_eval = 'pyeval'
		let s:py_version = 2
	elseif has('python3')
		let s:py_cmd = 'py3'
		let s:py_eval = 'py3eval'
		let s:py_version = 3
	else
		call keysound#errmsg('vim does not support +python/+python3 feature')
	endif
elseif g:keysound_py_version == 2
	if has('python')
		let s:py_cmd = 'py'
		let s:py_eval = 'pyeval'
		let s:py_version = 2
	else
		call keysound#errmsg('vim does not support +python feature')
	endif
elseif g:keysound_py_version == 3
	if has('python')
		let s:py_cmd = 'py3'
		let s:py_eval = 'py3eval'
		let s:py_version = 3
	else
		call keysound#errmsg('vim does not support +python3 feature')
	endif
endif

function! s:python(script)
	exec s:py_cmd a:script
endfunc

function! s:pyeval(script)
	if s:py_version == 2
		return pyeval(a:script)
	else
		return pyeval(a:script)
	endif
endfunc

call s:python('import sys')
call s:python('import vim')
call s:python('sys.path.append(vim.eval("s:scripthome"))')

let s:inited = 0
let s:last_theme = ''


"----------------------------------------------------------------------
" play a sound
"----------------------------------------------------------------------
function! s:play(filename, ...)
	let s:volume = (a:0 > 0)? a:1 : 1000
	let s:filename = a:filename
	if s:inited == 0
		call s:python('import keysound')
		let s:init = 1
	endif
	call s:python('v = int(vim.eval("s:volume")) * 0.001')
	call s:python('keysound.playsound(vim.eval("s:filename"), v)')
endfunc



