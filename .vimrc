" Définir la touche leader
let mapleader = " "

" Fonction pour insérer l'en-tête 42 exact
function! Insert42Header()
    let l:date = strftime("%Y/%m/%d %H:%M:%S")
    let l:filename = expand("%:t")
    let l:username = $USER
    let l:email = l:username . "@student.42.fr"

    " Insérer le header en haut du fichier avec le bon format et alignement
    call setline(1, '/* ************************************************************************** */')
    call append(1, '/*                                                                            */')
    call append(2, '/*                                                        :::      ::::::::   */')
    call append(3, '/*   ' . l:filename . '                                       :+:      :+:    :+:   */')
    call append(4, '/*                                                    +:+ +:+         +:+     */')
    call append(5, '/*   By: ' . l:username . ' <' . l:email . '>          +#+  +:+       +#+        */')
    call append(6, '/*                                                +#+#+#+#+#+   +#+           */')
    call append(7, '/*   Created: ' . l:date . ' by ' . l:username . '        #+#    #+#             */')
    call append(8, '/*   Updated: ' . l:date . ' by ' . l:username . '        ###   ########.fr       */')
    call append(9, '/*                                                                            */')
    call append(10, '/* ************************************************************************** */')
endfunction

" Raccourci pour insérer le header
nnoremap <Leader>h :call Insert42Header()<CR>

nnoremap <F2> :w<CR>

