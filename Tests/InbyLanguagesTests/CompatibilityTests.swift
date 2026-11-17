import Foundation
import SwiftTreeSitter
import XCTest
@testable import InbyLanguages

final class CompatibilityTests: XCTestCase {
    // The existing editor accepts these categories and favors lower capture IDs.
    private let editorCategories: Set<String> = [
        "include", "constructor", "keyword", "boolean", "repeat", "conditional",
        "tag", "comment", "variable", "property", "function", "method", "number",
        "float", "string", "type", "parameter", "type_alternate", "variable.builtin",
        "keyword.return", "keyword.function", "constant", "constant.builtin"
    ]

    func testSwiftKeepsEditorCategoriesAndSpecificCapturePrecedence() throws {
        let text = """
        import Foundation
        public struct Demo {
            public func greet(_ name: String) -> Int {
                let fraction = 1.5
                let optional: Int? = nil
                if true { for value in [1] { print(value) } }
                return 42
            }
        }
        """
        let captures = try resolvedCaptures(.swift, text)
        for (token, expected) in [
            ("import", "include"), ("public", "keyword"), ("struct", "keyword"),
            ("greet", "method"), ("name", "parameter"), ("if", "conditional"),
            ("for", "repeat"), ("1.5", "float"), ("nil", "variable.builtin")
        ] {
            let range = (text as NSString).range(of: token)
            XCTAssertEqual(winning(captures, at: range), expected, token)
        }
    }

    func testJSXTagsWinOverGeneralVariables() throws {
        let text = "const element = <div>hello</div>;"
        let captures = try resolvedCaptures(.jsx, text)
        XCTAssertEqual(winning(captures, at: (text as NSString).range(of: "div")), "tag")
    }

    func testBashColoursSubstitutionDelimitersAndKeepsInnerCaptures() throws {
        let text = "echo $(git rev-parse --short HEAD) ${HOME}"
        let captures = try resolvedCaptures(.bash, text)
        let ns = text as NSString
        for (token, expected) in [
            ("$(", "variable"), (")", "variable"), ("${", "variable"), ("}", "variable"),
            ("git", "function"), ("--short", "constant"), ("HOME", "property"), ("echo", "function")
        ] {
            XCTAssertEqual(winning(captures, at: ns.range(of: token)), expected, token)
        }
        // The editor drops any capture that starts inside an earlier, wider one,
        // so nothing coloured may span the whole substitution.
        let substitution = ns.range(of: "$(git rev-parse --short HEAD)")
        let shadowing = captures.filter {
            editorCategories.contains($0.name ?? "") && NSIntersectionRange($0.range, substitution) == substitution
        }
        XCTAssertTrue(shadowing.isEmpty, shadowing.map { $0.name ?? "" }.joined(separator: ","))
    }

    func testPythonDocstringsReadAsCommentsAndOtherStringsStayStrings() throws {
        let text = """
        \"\"\"Module doc.\"\"\"
        import os


        class Demo:
            \"\"\"Class doc.\"\"\"

            def run(self):
                \"\"\"Function doc.\"\"\"
                value = "plain"
                \"\"\"Not a docstring.\"\"\"
                return value
        """
        let captures = try resolvedCaptures(.python, text)
        let ns = text as NSString
        for (token, expected) in [
            ("\"\"\"Module doc.\"\"\"", "comment"), ("\"\"\"Class doc.\"\"\"", "comment"),
            ("\"\"\"Function doc.\"\"\"", "comment"), ("\"plain\"", "string"),
            ("\"\"\"Not a docstring.\"\"\"", "string")
        ] {
            XCTAssertEqual(winning(captures, at: ns.range(of: token)), expected, token)
        }

        let shebang = "#!/usr/bin/env python3\n\"\"\"Script doc.\"\"\"\nx = 1\n"
        let script = try resolvedCaptures(.python, shebang)
        let doc = (shebang as NSString).range(of: "\"\"\"Script doc.\"\"\"")
        XCTAssertEqual(winning(script, at: doc), "comment")
    }

    func testYAMLKeysReadAsPropertiesAndValuesKeepTheirCaptures() throws {
        let text = """
        name: demo
        "quoted": 'value'
        200: ok
        enabled: true
        flow: {inner: 1, "q": two}
        """
        let captures = try resolvedCaptures(.yaml, text)
        let ns = text as NSString
        for (token, expected) in [
            ("name", "property"), ("demo", "string"), ("\"quoted\"", "property"), ("'value'", "string"),
            ("200", "property"), ("enabled", "property"), ("true", "boolean"), ("flow", "property"),
            ("inner", "property"), ("1", "number"), ("\"q\"", "property"), ("two", "string")
        ] {
            XCTAssertEqual(winning(captures, at: ns.range(of: token)), expected, token)
        }
    }

    func testVersionedPythonAliasesWorkInModelines() {
        let url = URL(fileURLWithPath: "script")
        for line in ["// vim: ft=python3", "-*- mode: python2 -*-"] {
            XCTAssertEqual(CodeLanguage.detectLanguageFrom(url: url, prefixBuffer: line).id, .python)
        }
    }

    private func winning(_ captures: [QueryCapture], at range: NSRange) -> String? {
        captures.filter { $0.range == range && editorCategories.contains($0.name ?? "") }
            .min { $0.index < $1.index }?.name
    }

    private func resolvedCaptures(_ language: CodeLanguage, _ text: String) throws -> [QueryCapture] {
        let parser = Parser()
        try parser.setLanguage(XCTUnwrap(language.language))
        let tree = try XCTUnwrap(parser.parse(text))
        let query = try XCTUnwrap(TreeSitterModel.shared.query(for: language.id))
        let provider: SwiftTreeSitter.Predicate.TextProvider = { range, _ in
            guard NSMaxRange(range) <= (text as NSString).length else { return nil }
            return (text as NSString).substring(with: range)
        }
        return query.execute(in: tree).resolve(with: .init(textProvider: provider)).flatMap(\.captures)
    }
}
