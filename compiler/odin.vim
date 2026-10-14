" compiler/odin.vim
" Support for the Odin programming language
" Use with :compiler odin

if exists("current_compiler")
  finish
endif
let current_compiler = "odin"

CompilerSet makeprg=.\build.bat

CompilerSet errorformat=
      \%f(%l:%c)\ %trror:\ %m,
      \%f(%l:%c)\ %tarning:\ %m,
      \%f(%l:%c)\ %m,
