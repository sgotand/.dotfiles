call deoplete#custom#option('candidate_marks',
      \ ['A', 'S', 'D', 'F', 'G'])
inoremap <expr>A       pumvisible() ?
      \ deoplete#insert_candidate(0) : 'A'
inoremap <expr>S       pumvisible() ?
      \ deoplete#insert_candidate(1) : 'S'
inoremap <expr>D       pumvisible() ?
      \ deoplete#insert_candidate(2) : 'D'
inoremap <expr>F       pumvisible() ?
      \ deoplete#insert_candidate(3) : 'F'
inoremap <expr>G       pumvisible() ?
      \ deoplete#insert_candidate(4) : 'G'
