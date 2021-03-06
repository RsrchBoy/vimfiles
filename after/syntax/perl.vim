" Vim syntax file
" Language:      Perl 5 syntax extensions (Moose, Try::Tiny, etc)
" Maintainer:    Chris Weyl <cweyl@alumni.drew.edu>
" Last Change:   ...check GitHub :)

if !has_key(g:, 'perl_no_sql') " {{{
    let s:syn = b:current_syntax
    unlet b:current_syntax
    syntax include @SQL syntax/sql.vim
    let b:current_syntax = s:syn
    unlet s:syn
    syntax region perlHereDocSQL start=+<<['"]SQL['"].*;\s*$+ matchgroup=perlStringStartEnd end=+^SQL$+ contains=@SQL

    " indented!  req v5.26
    syntax region perlHereDocSQL start=/<<\~['"]SQL['"].*;\s*$/ matchgroup=perlStringStartEnd end=/^\s*SQL$/ contains=@SQL

    " Helps the heredoc be recognized regardless of where it's initiated
    syn cluster perlExpr add=perlHereDocSQL
endif " }}}

" $+ isn't picked up by perlVarPlain otherwise -- '+' is (correctly) not in
" isident or iskeyword
syn match  perlVarPlain "\$+" nextgroup=perlVarMember,perlVarSimpleMember,perlMethod,perlPostDeref

" in List::Util
syn match perlStatementList "\<\%(apply\|reduce\|any\|all\|none\|notall\|first\|max\|maxstr\|min\|minstr\|product\|sum\|sum0\|pairs\|unpairs\|pairkeys\|pairvalues\|pairfirst\|pairgrep\|pairmap\|shuffle\|uniq\|uniqnum\|uniqstr\)\>\ze\%(\s*=>\)\!@"

" to remove 'undef'
syn clear perlOperator
syn match perlOperator  "\<\%(defined\|eq\|ne\|[gl][et]\|cmp\|not\|and\|or\|xor\|not\|bless\|ref\|do\)\>"
" must not match /^=/ because POD
syn match perlOperator           /\%(^\)\@!=/

" FIXME include code?
syn match perlDeref    /\\\ze[$@%]/ nextgroup=perlVarPlain

" <=>, =>, //, //=, ||, ||=, =~
syn match perlOperator '\%(<\==>\|//=\=\|||=\=\|=\~\)'
" *, *=, ., .=, +, +=, -, -=, etc
syn match perlOperator #[*.+-/]=\=#
" |, ||, etc
syn match perlOperator /[|&<>+-]\{1,2}/
syn match perlOperator /[?:^]/

" allow lines starting with ')->' to be matched, but don't match the ')'
syn match perlDerefOrInvoke     /)\=\_s*\zs->/
            \ nextgroup=perlFuncName,perlVarAsMethod,perlHashSlot,perlPostDeref,perlArraySlot
            \ skipwhite
syn match perlFuncName          +\_s*\zs\%(\h\|::\|'\w\)\%(\w\|::\|'\w\)*\_s*\|+
            \ contained
            \ contains=perlPackageRef,perlPackageDelimError
            \ nextgroup=perlMethodArgs,perlFuncName,perlDerefOrInvoke
            \ skipwhite
syn match perlPkgOrFunc         +'\@!\%(\h\|::\|'\w\)\%(\w\|::\|'\w\)*\ze\_s*\%(->\|(\)+
            \ contains=perlPackageRef,perlPackageDelimError
            \ nextgroup=perlDerefOrInvoke
syn match perlVarAsMethod       /\$\w\+/
            \ contained
            \ nextgroup=perlMethodArgs
syn match perlPackageDelimError /'/
            \ contained

" fixes qr{}'s where the highlighting doesn't close; e.g. this line
" from Statocles::App::Blog:
"       my $is_dated_path = qr{^$root/?(\d{4})/(\d{2})/(\d{2})/};
syn match perlSpecialString /\\[dDXvVhHRKsSwW]\%({\d\+\%(,\d*\)\=}\)\=/ contained extend

" NOTE these bits will only really work if we have g:perl_no_extended_vars
" set, as we're basically replacing it here.

syn match perl__ /__\%(FILE\|LINE\)__/

" this was messing up highlighting after something like: $+{...}
syn clear perlBraces

syntax region perlDATA matchgroup=PreProc start="^__DATA__$" skip="." end="." contains=@perlDATA

if get(g:, 'perl_no_extended_vars', 1) " {{{1

    " this seems somewhat borked, and interferes with our extended_vars stuff
    syn clear perlStatementIndirObjWrap

    syn cluster perlExpr contains=perlStatementScalar,
        \perlStatementRegexp,perlStatementNumeric,perlStatementList,
        \perlStatementHash,perlStatementFiles,perlStatementTime,
        \perlStatementMisc,perlVarPlain,perlVarPlain2,perlVarNotInMatches,
        \perlVarSlash,perlVarBlock,perlVarBlock2,perlShellCommand,perlFloat,
        \perlNumber,perlStringUnexpanded,perlString,perlQQ,perlArrow,
        \perlBraces,perlDeref

    syn region perlHashSlot matchgroup=Delimiter start="{" skip="\\}" end="}" contained contains=@perlExpr nextgroup=perlVarMember,perlVarSimpleMember,perlPostDeref,perlDerefOrInvoke extend
    syn match  perlHashSlot "{\s*\I\i*\s*}" nextgroup=perlVarMember,
        \perlVarSimpleMember,perlPostDeref,perlDerefOrInvoke,perlHashSlot
        \ contains=perlVarSimpleMemberName,perlHashSlotDelimiters
        \ contained extend
    " syn region perlArraySlot matchgroup=Delimiter start=/\[/ end=/\]/ contained
    syn match perlArraySlot /\[\d\+\]/ contained contains=perlDelimiters,perlNumber

    syn match  perlHashSlotDelimiters /[{}]/ contained
    syn match  perlVarSimpleMemberName  "\I\i*" contained

    syn match perlBlockDerefOps /[@$%]/ contained
    syn match perlBlockDeref    /[@$%]{/ contains=perlBlockDerefOps

    syn match  perlDelimiters /[{}[\]()]/

    syn match perlPackageConst  "__PACKAGE__" nextgroup=perlPostDeref,perlDerefOrInvoke
    syn match perlSubConst      "__SUB__" nextgroup=perlPostDeref,perlDerefOrInvoke
    syn match perlPostDeref     "\%($#\|[$@%&*]\)\*" contained
    syn region  perlPostDeref   start="\%($#\|[$@%&*]\)\[" skip="\\]" end="]" contained contains=@perlExpr nextgroup=perlVarSimpleMember,perlVarMember,perlPostDeref
    " syn region  perlPostDeref matchgroup=perlPostDeref start="\%($#\|[$@%&*]\){" skip="\\}" end="}" contained contains=@perlExpr nextgroup=perlVarSimpleMember,perlVarMember,perlPostDeref
endif " }}}1

" syn region perlRegexp matchgroup=perlOperator start=#=\~\ze\s\+/# end=+/\ze;$+
syn region perlRegexp matchgroup=perlOperator start=#=\~\ze\s\+/# end=+/+
            \ keepend extend
            \ contains=@perlInterpSlash
            " \ contains=perlQQ

" syn region perlQQ matchgroup=perlStringStartEnd start=+/+  end=+/[imosxdual]*+ contains=@perlInterpSlash keepend extend contained
" syn region perlQQ matchgroup=perlStringStartEnd start=+/+  end=+/[imosxdual]*+ contains=@perlInterpSlash contained

hi link perlBlockDeref         Delimiter
hi link perlBlockDerefOps      perlOperator
hi link perlDelimiters         Delimiter
hi link perlDeref              Operator
hi link perlDerefOrInvoke      Operator
hi link perlFuncName           Function
hi link perlHashSlotDelimiters Delimiter
hi link perlPackageConst       Macro
hi link perlPackageDelimError  Error
hi link perlPkgOrFunc          Function
hi link perlPostDeref          Operator
hi link perlSubConst           Macro
hi link perlVarAsMethod        Identifier
hi link perl__                 Macro

syn match perlLineDelimiter /;$/
hi link perlLineDelimiter Delimiter

if !get(g:, 'perl_use_region', 0) " {{{

    " syn keyword perlIncludeUse    nextgroup=perlIncludeUsedPkg containedin= use
    syn keyword perlUse         skipwhite nextgroup=perlUsedPkg,perlUsedPerlVer use
    syn match   perlUsedPkg     +\%(\h\|::\|'\w\)\%(\w\|::\|'\w\)*\ze\%(;\|\_s\+\)+       contained contains=perlPackageDelimError
    syn match   perlUsedPerlVer /\%(v5.\d\d\=\|5.\d\d\d\)/      contained

    " syn region perlUseConstant start=/\<use\s+constant/ end=/=>/

    hi link perlUse         Include
    hi link perlUsedPkg     perlType
    hi link perlUsedPerlVer PreCondit

else " {{{

    " this is experimental, unfinished, and more of itch-scratching, really.
    syn region perlUseRegion matchgroup=perlStatementUse start=/^\s*use\>/ matchgroup=Delimiter end=/;/

    hi link perlStatementUse Include
endif " }}}1

syn match perlOperator           "\<\%(blessed\)\>"

syn keyword perlStatement with requires

" syn match   perlVarScalar  +$\%(\h\|::\|'\w\)\%(\w\|::\|'\w\)*\_s*\|+ contained

" TODO needs to be able to handle Moo-style bits like:
"
" has 'site';
" has options => sub { {} };
" has cleanup => sub { Mojo::Collection->new };
syn region perlAttribute
\   matchgroup=Statement    start='^\s*has\>'
\   matchgroup=perlOperator end='=>'
syn region perlMethodModifier  matchgroup=perlStatementMethodModifier start='^\s*\<\%(before\|after\|around\|override\|augment\)\>' matchgroup=perlOperator end=/=>\s*/ nextgroup=perlFunction,perlVarScalar,perlSubRef,perlMMError
" matches if (sub or \& or $\k+ matches) doesn't match
syn match perlMMError /\(sub\&\|\\&\&\|$\k\+\&\)\@!.*/ contained

syn match perlSubRef   /\\&\h\k\+/ contains=perlOperator
syn match perlOperator /\\&/ nextgroup=perlFuncName

hi link perlStatementMethodModifier perlStatement
hi link perlMethodModifier          perlSubName
hi link perlAttribute               perlSubName
hi link perlSubRef                  perlSubName
hi link perlMMError                 Error

" "normal"
syn match   perlTodo /\<\(NOTES\?\|TBD\|FIXME\|XXX\|PLAN\)[:]\?/ contained contains=NONE,@NoSpell

syn match perlPodWeaverSpecialComment "\C^# \zs[A-Z0-9]\+: " contained containedin=perlComment
syn match perlCriticOverride          /## \?\(no\|use\) critic.*$/ containedin=perlComment contained
syn match perlTidyOverride            /#\(<<<\|>>>\)$/ containedin=perlComment contained

" don't do spell checking in smart comments
syn region perlSmartComment start=/###/ end=/$/ oneline

hi link perlCriticOverride          Ignore
hi link perlTidyOverride            Ignore
hi link perlPodWeaverSpecialComment SpecialComment
hi link perlSmartComment            perlComment

" __END__
