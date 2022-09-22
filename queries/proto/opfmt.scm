; syntax = "proto3";
(syntax "=" @op (#opfmt! @op 3))

; option foo = true;
(option "=" @op (#opfmt! @op 3))

; enum Foo {}
(enum_body "{" @op (#opfmt! @op 1))

; enum Foo { A = 1; }
(enum_field "=" @op (#opfmt! @op 3))

; enum Foo { A = 1 []; }
(enum_field "[" @op (#opfmt! @op 1))

; enum Foo { A = 1 [ (x) = true ]; }
(enum_value_option "=" @op (#opfmt! @op 3))

; enum Foo { A = 1 [ (x) = true, (y) = true ]; }
(enum_field "," @op (#opfmt! @op 2))

; message Foo {}
(message_body "{" @op (#opfmt! @op 1))

; message Foo { int32 a = 1; }
(field "=" @op (#opfmt! @op 3))

; message Foo { int32 a = 1 []; }
(field "[" @op (#opfmt! @op 1))

; message Foo { int32 a = 1 [ (x) = true ]; }
(field_option "=" @op (#opfmt! @op 3))

; message Foo { int32 a = 1 [ (x)2= true, (y) = true ]; }
(field_options "," @op (#opfmt! @op 2))

; message Foo { oneof value {} }
(oneof "{" @op (#opfmt! @op 1))

; message Foo { oneof value { int32 a = 1; } }
(oneof_field "=" @op (#opfmt! @op 3))

; message Foo { oneof value { int32 a = 1 []; } }
(oneof_field "[" @op (#opfmt! @op 1))

; message Foo { int32 a = 1 [ (x) = { k : true } ] }
(block_lit ":" @op (#opfmt! @op 3))

; service FooService {}
(service "{" @op (#opfmt! @op 1))

; rpc Foo (Req) returns (Res);
(rpc "(" @op (#opfmt! @op 1))
(rpc ")" @op (#opfmt! @op 2))
