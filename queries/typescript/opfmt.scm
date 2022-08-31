; inherits: ecma

; { a: 1 }
(object (pair ":" @op (#opfmt! 2)))

; const a: T
(type_annotation ":" @op (#opfmt! 2))

; const a: T | U
(union_type "|" @op (#opfmt! 3))

; const a: T & U
(intersection_type "&" @op (#opfmt! 3))

; const a: T<A, B>
(type_arguments "," @op (#opfmt! 2))

; const a: [T, U]
(tuple_type "," @op (#opfmt! 2))

; const a: { [k: number]: v }
(index_signature ":" @op (#opfmt! 2))
