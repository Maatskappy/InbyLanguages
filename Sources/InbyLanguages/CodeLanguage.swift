import Foundation
import SwiftTreeSitter

/// Stable identifiers shared by grammars, query resources and embedded languages.
public enum TreeSitterLanguage: String, CaseIterable, Sendable {
    case agda
    case bash
    case c
    case cpp
    case cSharp
    case css
    case dart
    case dockerfile
    case elixir
    case go
    case goMod
    case haskell
    case html
    case java
    case javascript
    case jsdoc
    case json
    case jsx
    case julia
    case kotlin
    case lua
    case markdown
    case markdownInline
    case objc
    case ocaml
    case ocamlInterface
    case perl
    case php
    case python
    case regex
    case ruby
    case rust
    case scala
    case sql
    case swift
    case toml
    case tsx
    case typescript
    case verilog
    case yaml
    case zig
    case plainText
}

/// Language metadata and a source-built tree-sitter grammar.
public struct CodeLanguage: Hashable, Sendable {
    public let id: TreeSitterLanguage
    public let tsName: String
    public let extensions: Set<String>
    public let lineCommentString: String
    public let rangeCommentStrings: (String, String)
    public let additionalHighlights: Set<String>?

    init(_ id: TreeSitterLanguage, name: String, extensions: [String],
         lineComment: String, blockComment: (String, String), injections: Bool = false) {
        self.id = id
        self.tsName = name
        self.extensions = Set(extensions)
        self.lineCommentString = lineComment
        self.rangeCommentStrings = blockComment
        self.additionalHighlights = injections ? ["injections"] : nil
    }

    public var language: Language? { GrammarCatalog.language(for: id) }
    public var queryURL: URL? { Self.queryResource(id == .jsx ? "javascript" : tsName, "highlights") }

    public var parentQueryURL: URL? {
        switch id {
        case .cpp, .objc: return Self.c.queryURL
        case .typescript, .tsx: return Self.javascript.queryURL
        default: return nil
        }
    }

    static func queryResource(_ directory: String, _ name: String) -> URL? {
        Bundle.module.url(forResource: name, withExtension: "scm", subdirectory: "Resources/Queries/" + directory)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
