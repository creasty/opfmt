; let a = 1 + 2
(binary_operation _ @op (match_case)? (#lua-match? @op "^%p+$") (#not-eq? @op "#") (#opfmt! @op 3))

; FIXME
; let a = b ==# c
; (binary_operation ["==" "!=" "=~" "!~"] . (match_case) @op (#opfmt! @op -2))

; let a = 1
; let a += 1
(let_statement _ @op (#lua-match? @op "=$") (#opfmt! @op 3))

; let a = [1, 2]
(list "," @op (#opfmt! @op 2))

; let [a, b] = l
(list_assignment "," @op (#opfmt! @op 2))

; let a = { 'b': 1, 'c': 2 }
(dictionnary "," @op (#opfmt! @op 2))

; call fn(1, 2)
(call_expression "," @op (#opfmt! @op 2))

; let a = { 'b': 1 }
(dictionnary_entry ":" @op (#opfmt! @op 2))
