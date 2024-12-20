" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    .vimrc                                             :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: pbondoer <pbondoer@student.42.fr>          +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2015/12/06 19:39:01 by pbondoer          #+#    #+#              "
"    Updated: 2024/12/04 04:57:40 by killian          ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

" ty zaz <3
let s:asciiart = [
			\"        :::      ::::::::",
			\"      :+:      :+:    :+:",
			\"    +:+ +:+         +:+  ",
			\"  +#+  +:+       +#+     ",
			\"+#+#+#+#+#+   +#+        ",
			\"     #+#    #+#          ",
			\"    ###   ########.fr    "
			\]

let s:start		= '/*'
let s:end		= '*/'
let s:fill		= '*'
let s:length	= 80
let s:margin	= 5

let s:types		= {
			\'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.tpp$\|\.php\|\.glsl':
			\['/*', '*/', '*'],
			\'\.htm$\|\.html$\|\.xml$':
			\['<!--', '-->', '*'],
			\'\.js$':
			\['//', '//', '*'],
			\'\.tex$':
			\['%', '%', '*'],
			\'\.ml$\|\.mli$\|\.mll$\|\.mly$':
			\['(*', '*)', '*'],
			\'\.vim$\|\vimrc$':
			\['"', '"', '*'],
			\'\.el$\|\emacs$':
			\[';', ';', '*'],
			\'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
			\['!', '!', '/']
			\}

function! s:filetype()
	let l:f = s:filename()

	let s:start	= '#'
	let s:end	= '#'
	let s:fill	= '*'

	for type in keys(s:types)
		if l:f =~ type
			let s:start	= s:types[type][0]
			let s:end	= s:types[type][1]
			let s:fill	= s:types[type][2]
		endif
	endfor

endfunction

function! s:ascii(n)
	return s:asciiart[a:n - 3]
endfunction

function! s:textline(left, right)
	let l:left = strpart(a:left, 0, s:length - s:margin * 3 - strlen(a:right) + 1)

	return s:start . repeat(' ', s:margin - strlen(s:start)) . l:left . repeat(' ', s:length - s:margin * 2 - strlen(l:left) - strlen(a:right)) . a:right . repeat(' ', s:margin - strlen(s:end)) . s:end
endfunction

function! s:line(n)
	if a:n == 1 || a:n == 11 " top and bottom line
		return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
	elseif a:n == 2 || a:n == 10 " blank line
		return s:textline('', '')
	elseif a:n == 3 || a:n == 5 || a:n == 7 " empty with ascii
		return s:textline('', s:ascii(a:n))
	elseif a:n == 4 " filename
		return s:textline(s:filename(), s:ascii(a:n))
	elseif a:n == 6 " author
		return s:textline("By: " . s:user() . " <" . s:mail() . ">", s:ascii(a:n))
	elseif a:n == 8 " created
		return s:textline("Created: " . s:date() . " by " . s:user(), s:ascii(a:n))
	elseif a:n == 9 " updated
		return s:textline("Updated: " . s:date() . " by " . s:user(), s:ascii(a:n))
	endif
endfunction

function! s:user()
	let l:user = $USER
	if exists('g:hdr42user')
		let l:user = g:hdr42user
	endif
	if strlen(l:user) == 0
		let l:user = "killian"
	endif
	return l:user
endfunction

function! s:mail()
	let l:mail = $MAIL
	if exists('g:hdr42mail')
		let l:mail = g:hdr42mail
	endif
	if strlen(l:mail) == 0
		let l:mail = "killian@42.fr"
	endif
	return l:mail
endfunction

function! s:filename()
	let l:filename = expand("%:t")
	if strlen(l:filename) == 0
		let l:filename = "< new >"
	endif
	return l:filename
endfunction

function! s:date()
	return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function! s:insert()
	let l:line = 11

	" empty line after header
	call append(0, "")

	" loop over lines
	while l:line > 0
		call append(0, s:line(l:line))
		let l:line = l:line - 1
	endwhile
endfunction

function! s:update()
	call s:filetype()
	if getline(9) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
		if &mod
			call setline(9, s:line(9))
		endif
		call setline(4, s:line(4))
		return 0
	endif
	return 1
endfunction

function! s:stdheader()
	if s:update()
		call s:insert()
	endif
endfunction

" Bind command and shortcut
command! Stdheader call s:stdheader ()
nmap <f1> <esc>:Stdheader<CR>
autocmd BufWritePre * call s:update ()
nnoremap <F4> :w!<CR>
nnoremap <F5> :q!<CR>
" Ajouter un raccourci pour compiler avec gcc -Wall -Wextra -Werror en appuyant sur F3
autocmd FileType c nnoremap <F3> :!gcc -Wall -Wextra -Werror % -o %< && ./%< <CR>


syntax on
colorscheme 256_noir
set guifont=JetBrains\ Mono:h12


" Change highlighting of cursor line when entering/leaving Insert Mode
set cursorline
highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=233 guifg=NONE guibg=#121212
autocmd InsertEnter * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=234 guifg=NONE guibg=#1c1c1c
autocmd InsertLeave * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=233 guifg=NONE guibg=#121212


"Install formatter

if !filereadable(expand("~/.vim/plugged/c_formatter_42.vim/plugin/c_formatter_42.vim"))
    silent !git clone https://github.com/cacharle/c_formatter_42.vim ~/.vim/plugged/c_formatter_42.vim
endif

" Activer la coloration syntaxique
syntax on

" Numérotation des lignes
set number

" Activer la recherche incrémentale
set incsearch

" Afficher les correspondances de parenthèses
set showmatch

" Définir les espaces utilisés pour les tabulations
set tabstop=4
set shiftwidth=4
set expandtab

" Toujours afficher le statut de la ligne
set laststatus=2

" Activer la barre de statut
set ruler
set relativenumber

" Activer la barre de défilement latérale
set scrolloff=3
set termguicolors
highlight Normal guibg=#1c1c1c

" Active la syntaxe et configure la couleur pour les inclusions entre < et >
syntax enable
syntax match MyHeaderTag "<[^>]*>"
highlight MyHeaderTag ctermfg=magenta guifg=#800080
autocmd VimEnter * source ~/.vimrc

" Activer la barre de statut en permanence
set laststatus=2

" Configurer le contenu de la barre de statut
set statusline=%f\ %y\ %{&fileencoding}\ %p%%\ %l:%c

