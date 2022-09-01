; inherits: ecma

; const a: T
(type_annotation ":" @op (#opfmt! @op 2))

; const a: T | U
(union_type "|" @op (#opfmt! @op 3))

; const a: T & U
(intersection_type "&" @op (#opfmt! @op 3))

; const a: T<A, B>
(type_arguments "," @op (#opfmt! @op 2))

; const a: [T, U]
(tuple_type "," @op (#opfmt! @op 2))

; const a: { [k: T]: v }
(index_signature ":" @op (#opfmt! @op 2))
