; a + b
(binary_expression operator: _ @op (#opfmt! 3))

; a ? b : c
(ternary_expression ["?" ":"] @op (#opfmt! 3))

; let a = 1
; const a = 1
(variable_declarator "=" @op (#opfmt! 3))

; a = 1
(assignment_expression "=" @op (#opfmt! 3))

; a += 1
(augmented_assignment_expression _ @op (#lua-match? @op "=") (#opfmt! 3))

; (a = 1) => a
(required_parameter "=" @op (#opfmt! 3))

; () => a
(arrow_function "=>" @op (#opfmt! 3))

; (a, b) => a
(formal_parameters "," @op (#opfmt! 2))

; f(a, b)
(arguments "," @op (#opfmt! 2))

; [a, b]
(array "," @op (#opfmt! 2))

; { a, b }
(sequence_expression "," @op (#opfmt! 2))

; { a: 1 }
(object (pair ":" @op (#opfmt! 2)))
