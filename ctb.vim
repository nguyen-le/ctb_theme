"Nguyen's ctb scheme. borrowed skeleton from tomorrow night"
"https://github.com/chriskempson/tomorrow-theme"
"modified colors for ruby filetypes"
"still working on other types

" Default GUI Colours
let s:foreground = "c5c8c6"
let s:background = "272727"
let s:selection = "373b41"
let s:line = "282a2e"
let s:lightgray = "707070"
let s:xlightgray = "806060"
let s:comment = "464646"
let s:lightred = "e93636"
let s:red = "9D1616"
let s:orange = "e68a48"
let s:yellow = "eeb23a"
let s:paleyellow = "ffffa7"
let s:green = "3db83d"
let s:darkgreen = "6fad6f"
let s:aqua = "8abeb7"
let s:blue = "39b1ed"
let s:paleblue = "3597c4"
let s:darkblue = "19218c"
let s:purple = "6a3f7f"
let s:salmon = "c26b6b"
let s:palegreen = "76af58"
let s:darkpurple = "392cd0"
let s:lightpurple = "bb7bd7"
let s:window = "000000"
let s:integer = "5976c4"

" Console 256 Colours
if !has("gui_running")
  let s:background = "272727"
  let s:window = "5e5e5e"
  let s:line = "3a3a3a"
  let s:selection = "353535"

  let s:foreground = "c5c8c6"
  let s:lightgray = "808080"
  let s:comment = "484848"
  let s:lightred = "e93636"
  let s:red = "9d1616"
  let s:orange = "e68a48"
  let s:yellow = "e1a937"
  let s:paleyellow = "ffffa7"
  let s:aqua = "86d0d2"
  let s:blue = "52c1ed"
"  let s:blue = "39b1ed"
  let s:darkblue = "19218c"
  let s:purple = "5b386d"
  let s:purple = "a86ec1"
  "let s:purple = "6b4b7b"
  let s:darkpurple = "392cd0"
  let s:window = "000000"
end

set background=dark
hi clear
syntax reset

if has("gui_running") || &t_Co == 88 || &t_Co == 256
  " Returns an approximate grey index for the given grey level
  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " Returns the actual grey level represented by the grey index
  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  " Returns the palette index for the given grey index
  fun <SID>grey_colour(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 231 + a:n
      endif
    endif
  endfun

  " Returns an approximate colour index for the given colour level
  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " Returns the actual colour level for the given colour index
  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  " Returns the palette index for the given R/G/B colour indices
  fun <SID>rgb_colour(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  " Returns the palette index to approximate the given R/G/B colour levels
  fun <SID>colour(r, g, b)
    " Get the closest grey
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    " Get the closest colour
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      " There are two possibilities
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        " Use the grey
        return <SID>grey_colour(l:gx)
      else
        " Use the colour
        return <SID>rgb_colour(l:x, l:y, l:z)
      endif
    else
      " Only one possibility
      return <SID>rgb_colour(l:x, l:y, l:z)
    endif
  endfun

  " Returns the palette index to approximate the 'rrggbb' hex string
  fun <SID>rgb(rgb)
    let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
    let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
    let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

    return <SID>colour(l:r, l:g, l:b)
  endfun

  " Sets the highlighting for the given group
  fun <SID>X(group, fg, bg, attr)
    if a:fg != ""
      exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
    endif
    if a:bg != ""
      exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
    endif
    if a:attr != ""
      exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
    endif
  endfun

  " Vim Highlighting
  call <SID>X("Normal", s:foreground, s:background, "")
  call <SID>X("LineNr", s:lightgray, "", "")
  call <SID>X("NonText", s:red, "", "")
  call <SID>X("SpecialKey", s:selection, "", "")
  call <SID>X("Search", s:red, s:blue, "")
  call <SID>X("TabLine", s:foreground, s:background, "reverse")
  call <SID>X("StatusLine", s:window, s:yellow, "reverse")
  call <SID>X("StatusLineNC", s:window, s:foreground, "reverse")
  call <SID>X("VertSplit", s:window, s:window, "none")
  call <SID>X("Visual", "", s:selection, "")
  call <SID>X("Directory", s:blue, "", "")
  call <SID>X("ModeMsg", s:green, "", "")
  call <SID>X("MoreMsg", s:green, "", "")
  call <SID>X("Question", s:green, "", "")
  call <SID>X("WarningMsg", s:red, "", "")
  call <SID>X("MatchParen", "", s:xlightgray, "")
  call <SID>X("Folded", s:comment, s:background, "")
  call <SID>X("FoldColumn", "", s:background, "")
  if version >= 700
    call <SID>X("CursorLine", "", s:line, "none")
    call <SID>X("CursorColumn", "", s:line, "none")
    call <SID>X("PMenu", s:foreground, s:selection, "none")
    call <SID>X("PMenuSel", s:foreground, s:selection, "reverse")
    call <SID>X("SignColumn", "", s:background, "none")
  end
  if version >= 703
    call <SID>X("ColorColumn", "", s:line, "none")
  end

  " Standard Highlighting
  call <SID>X("Comment", s:paleblue, "", "")
  call <SID>X("Todo", s:yellow, s:background, "")
  call <SID>X("Boolean", s:integer, "", "underline")
  call <SID>X("Title", s:yellow, "", "")
  call <SID>X("Identifier", s:red, "", "none")
  call <SID>X("Statement", s:lightpurple, "", "")
  call <SID>X("Conditional", s:orange, "", "")
  call <SID>X("Repeat", s:green, "", "")
  call <SID>X("Structure", s:orange, "", "")
  call <SID>X("Function", s:blue, "", "")
  call <SID>X("Constant", s:orange, "", "")
  call <SID>X("String", s:darkgreen, "", "")
  call <SID>X("Special", s:lightpurple, "", "")
  call <SID>X("PreProc", s:yellow, "", "")
  call <SID>X("Operator", s:lightpurple, "", "none")
  call <SID>X("Type", s:lightpurple, "", "none")
  call <SID>X("Define", s:yellow, "", "none")
  call <SID>X("Include", s:blue, "", "")
  call <SID>X("Error", s:red, "", "")
  "call <SID>X("Ignore", "666666", "", "")

  " Vim Highlighting
  call <SID>X("vimCommand", s:orange, "", "none")

  " C Highlighting
  call <SID>X("cType", s:yellow, "", "")
  call <SID>X("cStorageClass", s:purple, "", "")
  call <SID>X("cConditional", s:purple, "", "")
  call <SID>X("cRepeat", s:purple, "", "")

  " PHP Highlighting
  call <SID>X("phpConditional", s:yellow, "", "")
  call <SID>X("phpComment", s:paleblue, "", "")
  call <SID>X("phpIdentifier", s:salmon, "", "")
  call <SID>X("phpKeyword", s:yellow, "", "")
  call <SID>X("phpRepeat", s:green, "", "")
  call <SID>X("phpMemberSelector", s:foreground, "", "")
  call <SID>X("phpStatement", s:green, "", "")
  call <SID>X("phpVarSelector", s:salmon, "", "")

  " Ruby Highlighting
  "call <SID>X("rubyIdentifier", s:red, "", "")
  "call <SID>X("rubyEval", s:red, "", "")
  "call <SID>X("rubyOperator", s:red, "", "")

  call <SID>X("rubyAttribute", s:salmon, "", "")
  call <SID>X("rubyBlockParameter", s:salmon, "", "")
  call <SID>X("rubyBlockArgument", s:salmon, "", "")
  call <SID>X("rubyBoolean", s:integer, "", "underline")
  call <SID>X("rubyClass", s:yellow, "", "")
  call <SID>X("rubyComment", s:paleblue, "", "")
  call <SID>X("rubyConditional", s:orange, "", "")
  call <SID>X("rubyConstant", s:yellow, "", "")
  call <SID>X("rubyControl", s:green, "", "")
  "call <SID>X("rubyCurlyBlock", s:purple, "", "")
  call <SID>X("rubyDefine", s:paleyellow, "", "")
  call <SID>X("rubyException", s:red, "", "")
  call <SID>X("rubyFunction", s:paleyellow, "", "bold")
  call <SID>X("rubyIdentifier", s:salmon, "", "")
  call <SID>X("rubyInclude", s:blue, "", "")
  call <SID>X("rubyInstanceVariable", s:salmon, "", "")
  call <SID>X("rubyInteger", s:integer, "", "")
  call <SID>X("rubyInterpolation", s:salmon, "", "")
  call <SID>X("rubyInterpolationDelimiter", s:salmon, "", "")
  call <SID>X("rubyKeyword", s:green, "", "")
  call <SID>X("rubyLocalVariableOrMethod", s:orange, "", "")
  "call <SID>X("rubyPredefinedVariable", s:purple, "", "")
  call <SID>X("rubyPseudoVariable", s:salmon, "", "")
  call <SID>X("rubyRepeat", s:green, "", "")
  call <SID>X("rubyString", s:darkgreen, "", "")
  call <SID>X("rubyStringDelimiter", s:darkgreen, "", "")
  call <SID>X("rubySymbol", s:salmon, "", "")
"  call <SID>X("rubyDoBlock", s:red, "", "")

  " Python Highlighting
  call <SID>X("pythonBuiltin", s:integer, "", "underline")
  call <SID>X("pythonClass", s:orange, "", "")
  call <SID>X("pythonClassName", s:orange, "", "")
  call <SID>X("pythonConditional", s:orange, "", "")
  call <SID>X("pythonDecorator", s:salmon, "", "")
  call <SID>X("pythonDef", s:orange, "", "")
  "call <SID>X("pythonDottedName", s:lightpurple, "", "")
  call <SID>X("pythonException", s:lightred, "", "")
  call <SID>X("pythonFunction", s:yellow, "", "")
  call <SID>X("pythonImport", s:blue, "", "")
  call <SID>X("pythonRepeat", s:green, "", "")
  call <SID>X("pythonStatement", s:green, "", "")
  call <SID>X("pythonBuiltinFunc", s:yellow, "", "")
  call <SID>X("pythonBuiltinObj", s:yellow, "", "")

  " Go Highlighting
  call <SID>X("goStatement", s:green, "", "")
  call <SID>X("goConditional", s:green, "", "")
  call <SID>X("goRepeat", s:green, "", "")
  call <SID>X("goException", s:red, "", "")
  call <SID>X("goDeclaration", s:blue, "", "")
  call <SID>X("goConstants", s:yellow, "", "")
  call <SID>X("goBuiltins", s:orange, "", "")

  " CoffeeScript Highlighting
  call <SID>X("coffeeKeyword", s:purple, "", "")
  call <SID>X("coffeeConditional", s:purple, "", "")

  " JavaScript Highlighting
  call <SID>X("Number", s:blue, "", "")
  "call <SID>X("jsBraces", s:lightgray, "", "")
  "call <SID>X("jsParens", s:lightgray, "", "")
  " Javascript vim-javascript highlight
  call <SID>X("jsAssignmentExpr", s:salmon, "", "")
  call <SID>X("jsAssignExpIdent", s:salmon, "", "")
  call <SID>X("jsFuncAssignExpr", s:salmon, "", "")
  call <SID>X("jsFuncAssignObjChain", s:salmon, "", "")
  call <SID>X("jsFuncAssignIdent", s:salmon, "", "")
  call <SID>X("jsFuncArrowArgs", s:salmon, "", "")
  call <SID>X("jsComment", s:paleblue, "", "")
  call <SID>X("jsBraces", s:orange, "", "")
  call <SID>X("jsException", s:red, "", "")
  call <SID>X("jsFunction", s:yellow, "", "")
  call <SID>X("jsFuncBraces", s:yellow, "", "")
  call <SID>X("jsFuncCall", s:aqua, "", "")
  call <SID>X("jsFuncParens", s:yellow, "", "")
  "call <SID>X("Function", s:paleyellow, "", "bold")
  call <SID>X("jsFuncArgs", s:salmon, "", "")
  call <SID>X("jsFuncArgRest", s:salmon, "", "")
  call <SID>X("jsFunctionKey", s:paleyellow, "", "bold")
  call <SID>X("jsGlobalObjects", s:palegreen, "", "")
  call <SID>X("jsKeyword", s:green, "", "")
  call <SID>X("jsObjectKey", s:salmon, "", "")
  call <SID>X("jsObjectKeys", s:salmon, "", "")
  call <SID>X("jsOperator", "bb7bd7", "", "")
  call <SID>X("jsModules", s:blue, "", "")
  call <SID>X("jsParens", s:yellow, "", "")
  call <SID>X("jsPrototype", s:salmon, "", "")
  call <SID>X("jsRepeat", s:green, "", "")
  call <SID>X("jsReturn", s:green, "", "")
  call <SID>X("jsRequire", s:blue, "", "")
  call <SID>X("jsSpecial", "bb7bd7", "", "")
  call <SID>X("jsThis", s:salmon, "", "")
  call <SID>X("jsStorageClass", s:purple, "", "")

  " Javascript vanilla highlight
  call <SID>X("javaScriptConditional", s:yellow, "", "")
  call <SID>X("javaScriptRepeat", s:green, "", "")
  call <SID>X("javaScriptNumber", s:integer, "", "")
  call <SID>X("javaScriptMember", s:orange, "", "")

  " HTML Highlighting
  call <SID>X("htmlTag", s:aqua, "", "")
  call <SID>X("htmlEndTag", s:red, "", "")
  call <SID>X("htmlTagName", s:aqua, "", "")
  call <SID>X("htmlArg", s:xlightgray, "", "")
  call <SID>X("htmlScriptTag", s:aqua, "", "")

  " CSS Highlighting
  call <SID>X("cssBraces", s:yellow, "","")
  call <SID>X("cssBraceError", s:lightred, "","")
  call <SID>X("cssClassName", s:salmon, "","")
  call <SID>X("cssFontAttr", s:yellow, "","")
  call <SID>X("cssPseudoClassId", s:yellow, "","")
  call <SID>X("cssTagName", s:yellow, "","")

	" Markdown Highlighting
  call <SID>X("markdownH1", s:lightred, "","")
  call <SID>X("markdownH2", s:orange, "","")
  call <SID>X("markdownH3", s:yellow, "","")
  call <SID>X("markdownH4", s:darkgreen, "","")
  call <SID>X("markdownHeadingRule", s:paleyellow, "","")
  call <SID>X("markdownHeadingDelimiter", s:paleyellow, "","")
  call <SID>X("markdownOrderedListMarker", s:paleblue, "","")
  call <SID>X("markdownListMarker", s:paleblue, "","")
  call <SID>X("markdownRule", s:red, "","")
  call <SID>X("markdownItalic", s:darkgreen, "","")
  call <SID>X("markdownBold", s:green, "","")

  " Diff Highlighting
  let s:diffbackground = "494e56"

  call <SID>X("diffAdded", s:green, "", "")
  call <SID>X("diffRemoved", s:red, "", "")
  call <SID>X("DiffAdd", s:green, s:diffbackground, "")
  call <SID>X("DiffDelete", s:red, s:diffbackground, "")
  call <SID>X("DiffChange", s:yellow, s:diffbackground, "")
  call <SID>X("DiffText", s:diffbackground, s:orange, "")

    " ShowMarks Highlighting
    call <SID>X("ShowMarksHLl", s:orange, s:background, "none")
    call <SID>X("ShowMarksHLo", s:palegreen, s:background, "none")
    call <SID>X("ShowMarksHLu", s:yellow, s:background, "none")
    call <SID>X("ShowMarksHLm", s:aqua, s:background, "none")

  " Delete Functions
  delf <SID>X
  delf <SID>rgb
  delf <SID>colour
  delf <SID>rgb_colour
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_colour
  delf <SID>grey_level
  delf <SID>grey_number
endif
