; local a = 1 + 2
(binary_expression _ @op (#lua-match? @op "^%p+$") (#opfmt! 3))

; local a = 1
(assignment_statement "=" @op (#opfmt! 3))

; local a = { k = 1 }
(table_constructor (field "=" @op (#opfmt! 3)))

; local a = { 1, 2 }
; local a = { k = 1, l = 2 }
(table_constructor "," @op (#opfmt! 2))

; local a = fn(1, 2)
(arguments "," @op (#opfmt! 2))

; for i = 0, 10 do end
(for_numeric_clause "=" @op (#opfmt! 3))
(for_numeric_clause "," @op (#opfmt! 2))
