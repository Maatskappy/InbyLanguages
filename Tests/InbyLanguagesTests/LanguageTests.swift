import Foundation
import SwiftTreeSitter
import XCTest
@testable import InbyLanguages

final class LanguageTests: XCTestCase {
    let withoutHighlights: Set<TreeSitterLanguage> = [.agda, .julia, .perl, .verilog]

    func testCatalogDetectionKeepsExtensionsAndPrecedence() {
        XCTAssertEqual(CodeLanguage.allLanguages.count, 41)
        XCTAssertEqual(Set(CodeLanguage.allLanguages.map(\.id)).count, 41)
        for language in CodeLanguage.allLanguages {
            for file in language.extensions {
                let name = file == "Dockerfile" ? file : "sample." + file.uppercased()
                let expected = file == "h" ? TreeSitterLanguage.c : language.id
                XCTAssertEqual(detect(name).id, expected, name)
            }
        }
        XCTAssertEqual(detect("Dockerfile").id, .dockerfile)
        XCTAssertEqual(detect("dockerfile").id, .plainText)
        XCTAssertEqual(detect("unknown.extension").id, .plainText)
        XCTAssertEqual(detect("notes.txt").id, .plainText)
        XCTAssertNil(CodeLanguage.default.language)
    }

    func testTextDetectionUsesFilenameThenShebangThenModeline() {
        XCTAssertEqual(detect("sample.swift", "#!/usr/bin/python3").id, .swift)
        XCTAssertEqual(detect("script", "#!/usr/bin/python3.12\nprint(42)").id, .python)
        XCTAssertEqual(detect("script", "#!/usr/bin/env -S python3 -u\nprint(42)").id, .python)
        XCTAssertEqual(detect("script", "#!/usr/bin/env OPTION=yes node\n42").id, .javascript)
        XCTAssertEqual(detect("script", "#!/usr/bin/env deno\n42").id, .javascript)
        XCTAssertEqual(detect("script", "#!/bin/bash\necho 42").id, .bash)
        XCTAssertEqual(detect("script", "// -*- mode: python -*-").id, .python)
        XCTAssertEqual(detect("script", "// vim: set ft=js ts=4").id, .javascript)
        XCTAssertEqual(CodeLanguage.detectLanguageFrom(url: URL(fileURLWithPath: "script"),
            suffixBuffer: "// vim: set ft=python").id, .python)
        XCTAssertEqual(detect("script", "#!/usr/bin/env").id, .plainText)
        XCTAssertEqual(detect("script", "ordinary text").id, .plainText)
    }

    func testEveryGrammarParsesAndEverySupportedQueryCompiles() throws {
        for language in CodeLanguage.allLanguages {
            let parser = Parser()
            try parser.setLanguage(XCTUnwrap(language.language))
            let sample = try XCTUnwrap(samples[language.id], language.id.rawValue)
            let tree = try XCTUnwrap(parser.parse(sample), language.id.rawValue)
            if withoutHighlights.contains(language.id) {
                XCTAssertNil(TreeSitterModel.shared.query(for: language.id))
                continue
            }
            do {
                let query = try XCTUnwrap(TreeSitterModel.shared.compileQuery(for: language.id))
                let captures = Array(query.execute(in: tree)).flatMap(\.captures)
                XCTAssertFalse(captures.isEmpty, language.id.rawValue)
                XCTAssertNotNil(TreeSitterModel.shared.query(for: language.id), language.id.rawValue)
            } catch {
                XCTFail("\(language.id.rawValue): \(error)")
            }
        }
    }

    func testCaptureCategoriesAndUTF16Ranges() throws {
        for (language, text, token, category) in [
            (CodeLanguage.swift, "let value = 42", "42", "number"),
            (.python, "value = 42", "42", "number"),
            (.json, "{\"value\": 42}", "42", "number"),
            (.javascript, "const value = 42;", "42", "number"),
            (.c, "int value = 42;", "42", "number"),
            (.html, "<div>hello</div>", "div", "tag")
        ] {
            let parser = Parser()
            try parser.setLanguage(XCTUnwrap(language.language))
            let tree = try XCTUnwrap(parser.parse(text))
            let query = try XCTUnwrap(TreeSitterModel.shared.query(for: language.id))
            let captures = Array(query.execute(in: tree)).flatMap(\.captures)
            let range = (text as NSString).range(of: token)
            XCTAssertTrue(captures.contains { $0.name == category && $0.range == range }, language.id.rawValue)
        }
    }

    func testCommentsAndEmbeddedLanguageMetadata() {
        XCTAssertEqual(CodeLanguage.python.lineCommentString, "#")
        XCTAssertEqual(CodeLanguage.swift.rangeCommentStrings.0, "/*")
        XCTAssertEqual(CodeLanguage.swift.rangeCommentStrings.1, "*/")
        XCTAssertEqual(CodeLanguage.html.rangeCommentStrings.0, "<!--")
        XCTAssertTrue(CodeLanguage.javascript.additionalHighlights?.contains("injections") == true)
        XCTAssertTrue(CodeLanguage.markdown.additionalHighlights?.contains("injections") == true)
        XCTAssertEqual(TreeSitterLanguage(rawValue: "jsdoc"), .jsdoc)
        XCTAssertEqual(TreeSitterLanguage(rawValue: "regex"), .regex)
        XCTAssertEqual(TreeSitterLanguage(rawValue: "markdownInline"), .markdownInline)
    }

    func testEmbeddedQueriesIdentifyTheirSourceLanguages() throws {
        for (language, text, expected) in [
            (CodeLanguage.html, "<script>const value = 42;</script><style>.a { color: red; }</style>", Set(["javascript", "css"])),
            (.javascript, "const expression = /hello+/; /** @param {string} name */", Set(["regex", "jsdoc"])),
            (.markdown, "*hello*\n", Set(["markdownInline"]))
        ] {
            let parser = Parser()
            try parser.setLanguage(XCTUnwrap(language.language))
            let tree = try XCTUnwrap(parser.parse(text))
            let query = try XCTUnwrap(TreeSitterModel.shared.query(for: language.id))
            let matches = Array(query.execute(in: tree))
            let injected = Set(matches.compactMap { $0.metadata["injection.language"] })
            XCTAssertTrue(expected.isSubset(of: injected), "\(language.id): \(injected)")
        }
    }

    private func detect(_ name: String, _ text: String? = nil) -> CodeLanguage {
        CodeLanguage.detectLanguageFrom(url: URL(fileURLWithPath: name), prefixBuffer: text)
    }

    private var samples: [TreeSitterLanguage: String] { [
        .agda: "module Demo where\n", .bash: "echo \"hello\"\n", .c: "int value = 42;\n",
        .cpp: "int value = 42;\n", .cSharp: "class Demo { int value = 42; }",
        .css: ".demo { width: 42px; }", .dart: "void main() { print(42); }",
        .dockerfile: "FROM alpine\n", .elixir: "value = 42\n", .go: "package demo\nvar value = 42\n",
        .goMod: "module example.org/demo\n", .haskell: "value = 42\n", .html: "<div>hello</div>",
        .java: "class Demo { int value = 42; }", .javascript: "const value = 42;",
        .jsdoc: "@param {string} name", .json: "{\"value\":42}", .jsx: "const value = <div>hello</div>;",
        .julia: "value = 42\n", .kotlin: "val value = 42", .lua: "local value = 42",
        .markdown: "# Hello\n", .markdownInline: "**hello**", .objc: "int value = 42;",
        .ocaml: "let value = 42", .ocamlInterface: "val value : int", .perl: "my $value = 42;",
        .php: "<?php $value = 42;", .python: "value = 42", .regex: "[a-z]+",
        .ruby: "value = 42", .rust: "fn main() { let value = 42; }", .scala: "val value = 42",
        .sql: "SELECT 42;", .swift: "let value = 42", .toml: "value = 42\n",
        .tsx: "const value = <div>hello</div>;", .typescript: "const value: number = 42;",
        .verilog: "module demo; endmodule", .yaml: "value: 42\n", .zig: "const value = 42;"
    ] }
}
