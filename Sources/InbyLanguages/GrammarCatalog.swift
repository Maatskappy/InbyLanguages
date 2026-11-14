import SwiftTreeSitter
import TreeSitterAgda
import TreeSitterBash
import TreeSitterC
import TreeSitterCSharp
import TreeSitterCPP
import TreeSitterCSS
import TreeSitterDart
import TreeSitterDockerfile
import TreeSitterElixir
import TreeSitterGo
import TreeSitterGoMod
import TreeSitterHaskell
import TreeSitterHTML
import TreeSitterJava
import TreeSitterJS
import TreeSitterJSDoc
import TreeSitterJSON
import TreeSitterJulia
import TreeSitterKotlin
import TreeSitterLua
import TreeSitterMarkdown
import TreeSitterMarkdownInline
import TreeSitterObjc
import TreeSitterOCaml
import TreeSitterPerl
import TreeSitterPHP
import TreeSitterPython
import TreeSitterRegex
import TreeSitterRuby
import TreeSitterRust
import TreeSitterScala
import TreeSitterSQL
import TreeSitterSwift
import TreeSitterTOML
import TreeSitterTypeScript
import TreeSitterVerilog
import TreeSitterYAML
import TreeSitterZig

enum GrammarCatalog {
    static func language(for id: TreeSitterLanguage) -> Language? {
        switch id {
        case .agda: return Language(tree_sitter_agda())
        case .bash: return Language(tree_sitter_bash())
        case .c: return Language(tree_sitter_c())
        case .cpp: return Language(tree_sitter_cpp())
        case .cSharp: return Language(tree_sitter_c_sharp())
        case .css: return Language(tree_sitter_css())
        case .dart: return Language(tree_sitter_dart())
        case .dockerfile: return Language(tree_sitter_dockerfile())
        case .elixir: return Language(tree_sitter_elixir())
        case .go: return Language(tree_sitter_go())
        case .goMod: return Language(tree_sitter_gomod())
        case .haskell: return Language(tree_sitter_haskell())
        case .html: return Language(tree_sitter_html())
        case .java: return Language(tree_sitter_java())
        case .javascript: return Language(tree_sitter_javascript())
        case .jsdoc: return Language(tree_sitter_jsdoc())
        case .json: return Language(tree_sitter_json())
        case .jsx: return Language(tree_sitter_javascript())
        case .julia: return Language(tree_sitter_julia())
        case .kotlin: return Language(tree_sitter_kotlin())
        case .lua: return Language(tree_sitter_lua())
        case .markdown: return Language(tree_sitter_markdown())
        case .markdownInline: return Language(tree_sitter_markdown_inline())
        case .objc: return Language(tree_sitter_objc())
        case .ocaml: return Language(tree_sitter_ocaml())
        case .ocamlInterface: return Language(tree_sitter_ocaml_interface())
        case .perl: return Language(tree_sitter_perl())
        case .php: return Language(tree_sitter_php())
        case .python: return Language(tree_sitter_python())
        case .regex: return Language(tree_sitter_regex())
        case .ruby: return Language(tree_sitter_ruby())
        case .rust: return Language(tree_sitter_rust())
        case .scala: return Language(tree_sitter_scala())
        case .sql: return Language(tree_sitter_sql())
        case .swift: return Language(tree_sitter_swift())
        case .toml: return Language(tree_sitter_toml())
        case .tsx: return Language(tree_sitter_tsx())
        case .typescript: return Language(tree_sitter_typescript())
        case .verilog: return Language(tree_sitter_verilog())
        case .yaml: return Language(tree_sitter_yaml())
        case .zig: return Language(tree_sitter_zig())
        case .plainText: return nil
        }
    }
}
