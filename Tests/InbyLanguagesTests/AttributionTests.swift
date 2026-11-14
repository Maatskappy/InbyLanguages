import Foundation
import XCTest

final class AttributionTests: XCTestCase {
    func testEverySelectedSourceHasLicenceAndCompleteNoticeText() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let data = try Data(contentsOf: root.appendingPathComponent("Vendor/grammars.json"))
        let manifest = try JSONDecoder().decode(Manifest.self, from: data)
        let notice = try String(contentsOf: root.appendingPathComponent("NOTICE"), encoding: .utf8)
        XCTAssertEqual(manifest.grammars.count, 37)
        for grammar in manifest.grammars {
            XCTAssertEqual(grammar.revision.count, 40, grammar.name)
            XCTAssertTrue(grammar.repository.hasPrefix("https://github.com/"), grammar.name)
            XCTAssertFalse(grammar.licenses.isEmpty, grammar.name)
            for path in grammar.licenses {
                let text = try String(contentsOf: root.appendingPathComponent(path), encoding: .utf8)
                XCTAssertFalse(text.isEmpty, path)
                XCTAssertTrue(notice.contains(text), path)
            }
            for query in grammar.queries {
                let path = root.appendingPathComponent("Sources/InbyLanguages").appendingPathComponent(query.resourcePath)
                XCTAssertTrue(FileManager.default.fileExists(atPath: path.path), query.resourcePath)
            }
        }
        for name in ["tree-sitter-kotlin", "tree-sitter-markdown"] {
            let entry = try XCTUnwrap(manifest.grammars.first { $0.name == name })
            XCTAssertTrue(entry.licenses.contains { $0.contains("APACHE-2.0") })
        }
        let haskell = try XCTUnwrap(manifest.grammars.first { $0.name == "tree-sitter-haskell" })
        XCTAssertTrue(haskell.licenses.contains { $0.contains("queries__LICENSE") })
        let elixir = try XCTUnwrap(manifest.grammars.first { $0.name == "tree-sitter-elixir" })
        XCTAssertTrue(elixir.licenses.contains { $0.hasSuffix("NOTICE") })
    }

    private struct Manifest: Decodable { let grammars: [Grammar] }
    private struct Grammar: Decodable {
        let name: String
        let repository: String
        let revision: String
        let licenses: [String]
        let queries: [Resource]
    }
    private struct Resource: Decodable { let resourcePath: String }
}
