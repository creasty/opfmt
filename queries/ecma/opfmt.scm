; a + b
(binary_expression operator: _ @op (#opfmt! @op 3))

; a ? b : c
(ternary_expression ["?" ":"] @op (#opfmt! @op 3))

; let a = 1
; const a = 1
(variable_declarator "=" @op (#opfmt! @op 3))

; a = 1
(assignment_expression "=" @op (#opfmt! @op 3))

; a += 1
(augmented_assignment_expression _ @op (#lua-match? @op "=") (#opfmt! @op 3))

; () => a
(arrow_function "=>" @op (#opfmt! @op 3))

; (a, b) => a
(formal_parameters "," @op (#opfmt! @op 2))

; f(a, b)
(arguments "," @op (#opfmt! @op 2))

; [a, b]
(array "," @op (#opfmt! @op 2))

; { a, b }
(sequence_expression "," @op (#opfmt! @op 2))

; { a: 1 }
(object (pair ":" @op (#opfmt! @op 2)))
