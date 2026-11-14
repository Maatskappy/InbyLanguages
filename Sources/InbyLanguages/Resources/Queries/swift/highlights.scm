; Modified: normalize capture categories for editor compatibility.
; General identifiers follow specific method/parameter/property captures.
[
  "."
  ";"
  ":"
  ","
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

; Identifiers
(type_identifier) @type

[
  (self_expression)
  (super_expression)
] @variable.builtin

; Declarations
[
  "func"
  "deinit"
] @keyword.function

[
  (visibility_modifier)
  (member_modifier)
  (function_modifier)
  (property_modifier)
  (parameter_modifier)
  (inheritance_modifier)
  (mutation_modifier)
] @keyword


(function_declaration
  (simple_identifier) @method)

(protocol_function_declaration
  name: (simple_identifier) @method)

(init_declaration
  "init" @constructor)

(parameter
  external_name: (simple_identifier) @parameter)

(parameter
  name: (simple_identifier) @parameter)

(type_parameter
  (type_identifier) @parameter)

(inheritance_constraint
  (identifier
    (simple_identifier) @parameter))

(equality_constraint
  (identifier
    (simple_identifier) @parameter))

[
  "protocol"
  "extension"
  "indirect"
  "nonisolated"
  "override"
  "convenience"
  "required"
  "some"
  "any"
  "weak"
  "unowned"
  "didSet"
  "willSet"
  "subscript"
  "let"
  "var"
  (throws)
  (where_keyword)
  (getter_specifier)
  (setter_specifier)
  (modify_specifier)
  (else)
  (as_operator)
] @keyword

[
  "enum"
  "struct"
  "class"
  "typealias"
] @keyword

[
  "async"
  "await"
] @keyword

(shebang_line) @keyword.directive

(class_body
  (property_declaration
    (pattern
      (simple_identifier) @property)))

(protocol_property_declaration
  (pattern
    (simple_identifier) @property))

(navigation_expression
  (navigation_suffix
    (simple_identifier) @property))

(value_argument
  name: (value_argument_label
    (simple_identifier) @property))

(import_declaration
  "import" @include)

(enum_entry
  "case" @keyword)

(modifiers
  (attribute
    "@" @attribute
    (user_type
      (type_identifier) @attribute)))

; Function calls
(call_expression
  (simple_identifier) @function.call) ; foo()

(call_expression
  ; foo.bar.baz(): highlight the baz()
  (navigation_expression
    (navigation_suffix
      (simple_identifier) @function.call)))

(call_expression
  (prefix_expression
    (simple_identifier) @function.call)) ; .foo()

((navigation_expression
  (simple_identifier) @type) ; SomeType.method(): highlight SomeType as a type
  (#match? @type "^[A-Z]"))

(directive) @keyword.directive

; See https://docs.swift.org/swift-book/documentation/the-swift-programming-language/lexicalstructure/#Keywords-and-Punctuation
[
  (diagnostic)
  (availability_condition)
  (playground_literal)
  (key_path_string_expression)
  (selector_expression)
  (external_macro_definition)
] @function.macro

(special_literal) @constant.macro

; Statements
(for_statement
  "for" @repeat)

(for_statement
  "in" @repeat)

[
  "while"
  "repeat"
  "continue"
  "break"
] @repeat

(guard_statement
  "guard" @conditional)

(if_statement
  "if" @conditional)

(switch_statement
  "switch" @conditional)

(switch_entry
  "case" @keyword)

(switch_entry
  "fallthrough" @keyword)

(switch_entry
  (default_keyword) @keyword)

"return" @keyword.return

(ternary_expression
  [
    "?"
    ":"
  ] @conditional)

[
  (try_operator)
  "do"
  (throw_keyword)
  (catch_keyword)
] @keyword

(statement_label) @label

; Comments
[
  (comment)
  (multiline_comment)
] @comment @spell

((comment) @comment
  (#match? @comment "^///[^/]"))

((comment) @comment
  (#match? @comment "^///$"))

((multiline_comment) @comment
  (#match? @comment "^/[*][*][^*].*[*]/$"))

; String literals
(line_str_text) @string

(str_escaped_char) @string

(multi_line_str_text) @string

(raw_str_part) @string

(raw_str_end_part) @string

(line_string_literal
  [
    "\\("
    ")"
  ] @punctuation.special)

(multi_line_string_literal
  [
    "\\("
    ")"
  ] @punctuation.special)

(raw_str_interpolation
  [
    (raw_str_interpolation_start)
    ")"
  ] @punctuation.special)

[
  "\""
  "\"\"\""
] @string

; Lambda literals
(lambda_literal
  "in" @keyword.operator)

; Basic literals
[
  (integer_literal)
  (hex_literal)
  (oct_literal)
  (bin_literal)
] @number

(real_literal) @float

(boolean_literal) @boolean

"nil" @variable.builtin

(wildcard_pattern) @character.special

; Regex literals
(regex_literal) @string.regex

; Operators
(custom_operator) @operator

[
  "+"
  "-"
  "*"
  "/"
  "%"
  "="
  "+="
  "-="
  "*="
  "/="
  "<"
  ">"
  "<<"
  ">>"
  "<="
  ">="
  "++"
  "--"
  "^"
  "&"
  "&&"
  "|"
  "||"
  "~"
  "%="
  "!="
  "!=="
  "=="
  "==="
  "?"
  "??"
  "->"
  "..<"
  "..."
  (bang)
] @operator

(type_arguments
  [
    "<"
    ">"
  ] @punctuation.bracket)

; General identifier styling has lower priority than specific roles.
(simple_identifier) @variable
