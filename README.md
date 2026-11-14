# InbyLanguages

Source-built tree-sitter grammars, language detection and highlight queries for Swift editors.

```swift
import InbyLanguages

let language = CodeLanguage.detectLanguageFrom(url: fileURL, prefixBuffer: firstLines)
let grammar = language.language
let query = TreeSitterModel.shared.query(for: language.id)
```

Add the `InbyLanguages` product from this repository as a Swift package dependency. Consumers should select an exact released version. The package uses SwiftTreeSitter 0.25.0 and tree-sitter 0.25.10; the Swift grammar uses exact tag `0.7.3-with-generated-files`. The other 36 grammars are vendored source snapshots at the exact revisions recorded in `Vendor/grammars.json`, so fresh consumers do not clone dozens of repository histories.

The catalog contains 41 language IDs backed by 37 source-built upstream repositories, plus a plain-text default. File detection checks extensions and special names such as `Dockerfile`, then optional shebang/modeline text. Extension matching is case-insensitive, filenames are case-sensitive, and `.h` resolves to C. JSDoc, regex and Markdown inline are embedded-language helpers. Agda, Julia, Perl and Verilog have grammars but no exposed highlight query.

The package offers metadata used by editing commands, native tree-sitter language values and immutable compiled queries. It has no dependency on an editor UI or a binary grammar container. Query composition includes upstream parent queries, JSX and embedded-language patterns.

The `TreeSitterJSON` product exposes the same vendored JSON parser to consumers that also use it directly, avoiding duplicate parser symbols.

## Licences and upstream inputs

Original Swift code is Apache-2.0. Grammar and query resources retain their upstream terms, which include MIT and Apache-2.0. `Vendor/grammars.json` records exact source revisions, selected runtime files, copied query paths, modifications and licence locations. `Vendor/Grammars` contains only runtime C/C++ source and headers; package source is compiled locally, without a binary framework. `Vendor/Licenses` retains full texts; `NOTICE` includes the attribution catalogue. Haskell and Kotlin highlight queries have separate Apache-2.0 provenance; Elixir retains its LICENSE/NOTICE split; Markdown highlights retain nvim-treesitter attribution alongside the grammar MIT grant.

Build and test on macOS with:

```sh
swift build
swift test
```

Tests exercise every grammar/query, language detection, editing metadata and capture ranges. Visual styling is supplied by the consuming editor.
