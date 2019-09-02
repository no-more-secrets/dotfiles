" syntax highlighting for haskell
"
" Heavily modified version of the haskell syntax
" highlighter to support haskell.
"
" author: raichoo (raichoo@googlemail.com)

if version < 600
  syn clear
elseif exists("b:current_syntax")
  finish
endif

syn match hsRecordField "[_a-z][a-zA-Z0-9_']*\s*::" contained
  \ contains=
  \ hsIdentifier,
  \ hsOperators
syn match hsTopLevelDecl "^\s*\(where\s\+\|let\s\+\|default\s\+\)\?[_a-z][a-zA-Z0-9_']*\(,\s*[_a-z][a-zA-Z0-9_']*\)*\(\s*::\|\n\s\+::\)"
  \ contains=
  \ hsIdentifier,
  \ hsOperators,
  \ hsDelimiter,
  \ hsWhere,
  \ hsLet,
  \ hsDefault
syn keyword hsBlockKeywords data type family module where class instance contained
if exists('g:hs_enable_pattern_synonyms') && g:hs_enable_pattern_synonyms == 1
  syn region hsModuleBlock start="\<module\>" end="\<where\>" keepend
    \ contains=
    \ hsType,
    \ hsDelimiter,
    \ hsDot,
    \ hsOperators,
    \ hsModule,
    \ hsBlockKeywords,
    \ hsLineComment,
    \ hsBlockComment,
    \ hsPragma,
    \ hsPreProc,
    \ hsPatternKeyword
else
  syn region hsModuleBlock start="\<module\>" end="\<where\>" keepend
    \ contains=
    \ hsType,
    \ hsDelimiter,
    \ hsDot,
    \ hsOperators,
    \ hsModule,
    \ hsBlockKeywords,
    \ hsLineComment,
    \ hsBlockComment,
    \ hsPragma,
    \ hsPreProc
endif
syn region hsBlock start="^\<\(class\|instance\)\>" end="\(\<where\>\|^\s*$\|^\<\)" keepend
  \ contains=
  \ hsType,
  \ hsDelimiter,
  \ hsDot,
  \ hsOperators,
  \ hsModule,
  \ hsBlockKeywords,
  \ hsLineComment,
  \ hsBlockComment,
  \ hsPragma,
  \ hsQuoted
syn region hsDataBlock start="^\<\(data\|type\)\>\(\s\+\<family\>\)\?" end="\([=]\|\<where\>\|^\s*$\|^\<\)" keepend
  \ contains=
  \ hsType,
  \ hsDelimiter,
  \ hsDot,
  \ hsOperators,
  \ hsModule,
  \ hsBlockKeywords,
  \ hsLineComment,
  \ hsBlockComment,
  \ hsPragma
syn match hsAssocType "\s\+\<\(data\|type\)\>"
syn keyword hsNewtype newtype
syn match hsDeriving "\(deriving\s\+instance\|deriving\)"
syn keyword hsDefault default
syn keyword hsImportKeywords import qualified safe as hiding contained
syn keyword hsForeignKeywords foreign export import ccall safe unsafe interruptible capi prim contained
syn region hsForeignImport start="\<foreign\>" end="::" keepend
  \ contains=
  \ hsString,
  \ hsOperators,
  \ hsForeignKeywords,
  \ hsIdentifier
syn region hsImport start="\<import\>" end="\((\|$\)" keepend
  \ contains=
  \ hsDelimiter,
  \ hsType,
  \ hsDot,
  \ hsImportKeywords,
  \ hsString
syn keyword hsStatement do case of in
syn keyword hsWhere where
syn keyword hsLet let
if exists('g:hs_enable_static_pointers') && g:hs_enable_static_pointers == 1
  syn keyword hsStatic static
endif
syn keyword hsConditional if then else
syn match hsNumber "\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>\|\<0[bB][10]\+\>"
syn match hsFloat "\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"
syn match hsDelimiter  "(\|)\|\[\|\]\|,\|;\|{\|}"
syn keyword hsInfix infix infixl infixr
syn keyword hsBottom undefined error
syn match hsOperators "[-!#$%&\*\+/<=>\?@\\^|~:]\+\|\<_\>"
syn match hsQuote "\<'\+" contained
syn match hsQuotedType "[A-Z][a-zA-Z0-9_']*\>" contained
syn region hsQuoted start="\<'\+" end="\>"
  \ contains=
  \ hsType,
  \ hsQuote,
  \ hsQuotedType,
  \ hsDelimiter,
  \ hsOperators,
  \ hsIdentifier
syn match hsDot "\."
syn match hsLineComment "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
  \ contains=
  \ hsTodo,
  \ @Spell
syn match hsBacktick "`[A-Za-z_][A-Za-z0-9_\.']*`"
syn region hsString start=+"+ skip=+\\\\\|\\"+ end=+"+
  \ contains=@Spell
syn region hsBlockComment start="{-" end="-}"
  \ contains=
  \ hsBlockComment,
  \ hsTodo,
  \ @Spell
syn region hsPragma start="{-#" end="#-}"
syn match hsIdentifier "[_a-z][a-zA-z0-9_']*" contained
syn match hsChar "\<'[^'\\]'\|'\\.'\|'\\u[0-9a-fA-F]\{4}'\>"
syn match hsType "\<[A-Z][a-zA-Z0-9_']*\>"
syn region hsRecordBlock start="[A-Z][a-zA-Z0-9']*\n\?\s\+{[^-]" end="[^-]}" keepend
  \ contains=
  \ hsType,
  \ hsDelimiter,
  \ hsOperators,
  \ hsDot,
  \ hsRecordField,
  \ hsString,
  \ hsChar,
  \ hsFloat,
  \ hsNumber,
  \ hsBacktick,
  \ hsLineComment,
  \ hsBlockComment,
  \ hsPragma,
  \ hsBottom,
  \ hsConditional,
  \ hsStatement,
  \ hsWhere,
  \ hsLet
syn match hsQuasiQuoteDelimiters "\[[_a-z][a-zA-z0-9_']*|\||\]" contained
syn region hsQuasiQuote start="\[[_a-z][a-zA-z0-9_']*|" end="|\]" keepend
  \ contains=hsQuasiQuoteDelimiters
syn match hsTHQuasiQuotes "\[||\|||\]\|\[|\||\]\|\[\(d\|t\|p\)|"
syn match hsPreProc "^#.*$"
syn keyword hsTodo TODO FIXME contained
if exists('g:hs_enable_typeroles') && g:hs_enable_typeroles == 1
  syn keyword hsTypeRoles type role phantom representational nominal contained
  syn region hsTypeRoleBlock start="type\s\+role" end="$" keepend
    \ contains=
    \ hsType,
    \ hsTypeRoles
endif
if exists('g:hs_enable_quantification') && g:hs_enable_quantification == 1
  syn keyword hsForall forall
endif
if exists('g:hs_enable_recursivedo') && g:hs_enable_recursivedo == 1
  syn keyword hsRecursiveDo mdo rec
endif
if exists('g:hs_enable_arrowsyntax') && g:hs_enable_arrowsyntax == 1
  syn keyword hsArrowSyntax proc
endif
if exists('g:hs_enable_pattern_synonyms') && g:hs_enable_pattern_synonyms == 1
  syn region hsPatternSynonyms start="^\s*pattern\s\+[A-Z][A-za-z0-9_]*\s*" end="=\|<-\|$" keepend
    \ contains=
    \ hsPatternKeyword,
    \ hsType,
    \ hsOperators
  syn keyword hsPatternKeyword pattern contained
endif

highlight def link hsBottom Macro
highlight def link hsQuasiQuoteDelimiters Boolean
highlight def link hsTHQuasiQuotes Boolean
highlight def link hsQuasiQuote String
highlight def link hsBlockKeywords Structure
" 2017-05-12 David Sicilia -- changed to add better highlighting of function names in type signature; use to be:
"highlight def link hsIdentifier Identifier
highlight def link hsIdentifier Function
highlight def link hsImportKeywords Structure
highlight def link hsForeignKeywords Structure
highlight def link hsNewtype Structure
highlight def link hsDeriving Structure
highlight def link hsStatement Statement
highlight def link hsWhere Statement
highlight def link hsLet Statement
highlight def link hsDefault Statement
highlight def link hsConditional Conditional
highlight def link hsNumber Number
highlight def link hsFloat Float
highlight def link hsDelimiter Delimiter
highlight def link hsInfix PreProc
highlight def link hsOperators Operator
highlight def link hsQuote Operator
highlight def link hsQuotedType Include
highlight def link hsDot Operator
highlight def link hsType Include
highlight def link hsLineComment Comment
highlight def link hsBlockComment Comment
" *** DS - highlight def link hsPragma SpecialComment
highlight def link hsPragma Operator
highlight def link hsString String
highlight def link hsChar String
highlight def link hsBacktick Operator
highlight def link hsPreProc Macro
highlight def link hsTodo Todo
highlight def link hsAssocType Structure
" 2017-05-12 David Sicilia -- added this line for better highlighting of function names in type signature
highlight def link hsFunction Function

if exists('g:hs_enable_quantification') && g:hs_enable_quantification == 1
  highlight def link hsForall Operator
endif
if exists('g:hs_enable_recursivedo') && g:hs_enable_recursivedo == 1
  highlight def link hsRecursiveDo Operator
endif
if exists('g:hs_enable_arrowsyntax') && g:hs_enable_arrowsyntax == 1
  highlight def link hsArrowSyntax Operator
endif
if exists('g:hs_enable_pattern_synonyms') && g:hs_enable_pattern_synonyms == 1
  highlight def link hsPatternKeyword Structure
endif
if exists('g:hs_enable_typeroles') && g:hs_enable_typeroles == 1
  highlight def link hsTypeRoles Structure
endif
if exists('g:hs_enable_static_pointers') && g:hs_enable_static_pointers == 1
  highlight def link hsStatic Statement
endif

let b:current_syntax = "hs"
