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

; void { a: 1 }
(object "," @op (#opfmt! @op 2))
(object (pair ":" @op (#opfmt! @op 2)))
; (object @parent "{" @op (#opfmt! @op 2) (#has-named-child? @parent))
; (object @parent "}" @op (#opfmt! @op 1) (#has-named-child? @parent))

; import { a, b } from "c";
(named_imports "{" @op (#opfmt! @op 3))
(named_imports "," @op (#opfmt! @op 2))
(named_imports "}" @op (#opfmt! @op 3))

; export { a, b };
(export_clause "{" @op (#opfmt! @op 1))
(export_clause "," @op (#opfmt! @op 2))

; for (let i = 0; i < 10; i++);
(for_statement initializer: (lexical_declaration ";" @op (#opfmt! @op 2)))
(for_statement condition: ";" @op (#opfmt! @op 2))
(for_statement "(" @op (#opfmt! @op 1))
(for_statement ")" @op (#opfmt! @op 2))

; if (a);
(if_statement condition: (parenthesized_expression "(" @op (#opfmt! @op 1)))
(if_statement condition: (parenthesized_expression ")" @op (#opfmt! @op 2)))

; while (a);
(while_statement condition: (parenthesized_expression "(" @op (#opfmt! @op 1)))
(while_statement condition: (parenthesized_expression ")" @op (#opfmt! @op 2)))

; switch (a) {}
(switch_statement value: (parenthesized_expression "(" @op (#opfmt! @op 1)))
(switch_statement value: (parenthesized_expression ")" @op (#opfmt! @op 2)))

; function a() {}
(function_declaration parameters: (formal_parameters ")" @op (#opfmt! @op 2)))

; class A { a() {} }
(method_definition parameters: (formal_parameters ")" @op (#opfmt! @op 2)))
