import Foundation

public extension CodeLanguage {
    static let agda = CodeLanguage(.agda, name: "agda", extensions: ["agda"], lineComment: "--", blockComment: ("{-", "-}"))
    static let bash = CodeLanguage(.bash, name: "bash", extensions: ["sh", "bash"], lineComment: "#", blockComment: (":'", "'"))
    static let c = CodeLanguage(.c, name: "c", extensions: ["c", "h"], lineComment: "//", blockComment: ("/*", "*/"))
    static let cpp = CodeLanguage(.cpp, name: "cpp", extensions: ["cc", "cpp", "c++", "hpp", "h"], lineComment: "//", blockComment: ("/*", "*/"), injections: true)
    static let cSharp = CodeLanguage(.cSharp, name: "c-sharp", extensions: ["cs"], lineComment: "//", blockComment: ("/*", "*/"))
    static let css = CodeLanguage(.css, name: "css", extensions: ["css"], lineComment: "", blockComment: ("/*", "*/"))
    static let dart = CodeLanguage(.dart, name: "dart", extensions: ["dart"], lineComment: "//", blockComment: ("/*", "*/"))
    static let dockerfile = CodeLanguage(.dockerfile, name: "dockerfile", extensions: ["Dockerfile"], lineComment: "#", blockComment: ("", ""))
    static let elixir = CodeLanguage(.elixir, name: "elixir", extensions: ["ex", "exs"], lineComment: "#", blockComment: ("", ""), injections: true)
    static let go = CodeLanguage(.go, name: "go", extensions: ["go"], lineComment: "//", blockComment: ("/*", "*/"))
    static let goMod = CodeLanguage(.goMod, name: "go-mod", extensions: ["mod"], lineComment: "//", blockComment: ("/*", "*/"))
    static let haskell = CodeLanguage(.haskell, name: "haskell", extensions: ["hs"], lineComment: "--", blockComment: ("{-", "-}"))
    static let html = CodeLanguage(.html, name: "html", extensions: ["html", "htm", "shtml"], lineComment: "", blockComment: ("<!--", "-->"), injections: true)
    static let java = CodeLanguage(.java, name: "java", extensions: ["java", "jav"], lineComment: "//", blockComment: ("/*", "*/"))
    static let javascript = CodeLanguage(.javascript, name: "javascript", extensions: ["js", "cjs", "mjs"], lineComment: "//", blockComment: ("/*", "*/"), injections: true)
    static let jsdoc = CodeLanguage(.jsdoc, name: "jsdoc", extensions: [], lineComment: "", blockComment: ("/**", "*/"))
    static let json = CodeLanguage(.json, name: "json", extensions: ["json"], lineComment: "//", blockComment: ("/*", "*/"))
    static let jsx = CodeLanguage(.jsx, name: "javascript", extensions: ["jsx"], lineComment: "//", blockComment: ("/*", "*/"), injections: true)
    static let julia = CodeLanguage(.julia, name: "julia", extensions: ["jl"], lineComment: "#", blockComment: ("#=", "=#"))
    static let kotlin = CodeLanguage(.kotlin, name: "kotlin", extensions: ["kt", "kts"], lineComment: "//", blockComment: ("/*", "*/"))
    static let lua = CodeLanguage(.lua, name: "lua", extensions: ["lua"], lineComment: "--", blockComment: ("-[[", "]]--"), injections: true)
    static let markdown = CodeLanguage(.markdown, name: "markdown", extensions: ["md", "mkd", "mkdn", "mdwn", "mdown", "markdown"], lineComment: "[comment]: #", blockComment: ("", ""), injections: true)
    static let markdownInline = CodeLanguage(.markdownInline, name: "markdown-inline", extensions: [], lineComment: "", blockComment: ("", ""), injections: true)
    static let objc = CodeLanguage(.objc, name: "objc", extensions: ["m", "h"], lineComment: "//", blockComment: ("/*", "*/"), injections: true)
    static let ocaml = CodeLanguage(.ocaml, name: "ocaml", extensions: ["ml"], lineComment: "", blockComment: ("(*", "*)"))
    static let ocamlInterface = CodeLanguage(.ocamlInterface, name: "ocaml", extensions: ["mli"], lineComment: "", blockComment: ("", ""))
    static let perl = CodeLanguage(.perl, name: "perl", extensions: ["pl", "pm"], lineComment: "#", blockComment: ("=pod", "=cut"))
    static let php = CodeLanguage(.php, name: "php", extensions: ["php"], lineComment: "//", blockComment: ("/*", "*/"), injections: true)
    static let python = CodeLanguage(.python, name: "python", extensions: ["py"], lineComment: "#", blockComment: ("", ""))
    static let regex = CodeLanguage(.regex, name: "regex", extensions: [], lineComment: "", blockComment: ("", ""))
    static let ruby = CodeLanguage(.ruby, name: "ruby", extensions: ["rb"], lineComment: "#", blockComment: ("=begin", "=end"))
    static let rust = CodeLanguage(.rust, name: "rust", extensions: ["rs"], lineComment: "//", blockComment: ("/*", "*/"), injections: true)
    static let scala = CodeLanguage(.scala, name: "scala", extensions: ["scala", "sc"], lineComment: "//", blockComment: ("/*", "*/"))
    static let sql = CodeLanguage(.sql, name: "sql", extensions: ["sql"], lineComment: "--", blockComment: ("/*", "*/"))
    static let swift = CodeLanguage(.swift, name: "swift", extensions: ["swift"], lineComment: "//", blockComment: ("/*", "*/"))
    static let toml = CodeLanguage(.toml, name: "toml", extensions: ["toml"], lineComment: "#", blockComment: ("", ""))
    static let tsx = CodeLanguage(.tsx, name: "typescript", extensions: ["tsx"], lineComment: "//", blockComment: ("/*", "*/"))
    static let typescript = CodeLanguage(.typescript, name: "typescript", extensions: ["ts", "cts", "mts"], lineComment: "//", blockComment: ("/*", "*/"))
    static let verilog = CodeLanguage(.verilog, name: "verilog", extensions: ["v"], lineComment: "//", blockComment: ("/*", "*/"))
    static let yaml = CodeLanguage(.yaml, name: "yaml", extensions: ["yml", "yaml"], lineComment: "#", blockComment: ("", ""))
    static let zig = CodeLanguage(.zig, name: "zig", extensions: ["zig"], lineComment: "//", blockComment: ("", ""), injections: true)
    static let `default` = CodeLanguage(.plainText, name: "PlainText", extensions: ["txt"], lineComment: "", blockComment: ("", ""))

    /// Catalog order also resolves ambiguous filename extensions.
    static let allLanguages: [CodeLanguage] = [
        .agda,
        .bash,
        .c,
        .cpp,
        .cSharp,
        .css,
        .dart,
        .dockerfile,
        .elixir,
        .go,
        .goMod,
        .haskell,
        .html,
        .java,
        .javascript,
        .jsdoc,
        .json,
        .jsx,
        .julia,
        .kotlin,
        .lua,
        .markdown,
        .markdownInline,
        .objc,
        .ocaml,
        .ocamlInterface,
        .perl,
        .php,
        .python,
        .regex,
        .ruby,
        .rust,
        .scala,
        .sql,
        .swift,
        .toml,
        .tsx,
        .typescript,
        .verilog,
        .yaml,
        .zig,
    ]
}
