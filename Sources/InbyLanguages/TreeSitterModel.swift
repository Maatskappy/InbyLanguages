import Foundation
import SwiftTreeSitter

/// Shares immutable compiled queries between editor instances.
public final class TreeSitterModel: @unchecked Sendable {
    public static let shared = TreeSitterModel()
    private let lock = NSLock()
    private var queries: [TreeSitterLanguage: Query] = [:]
    private init() {}

    public func query(for language: TreeSitterLanguage) -> Query? {
        lock.lock()
        defer { lock.unlock() }
        if let cached = queries[language] { return cached }
        guard let compiled = try? compileQuery(for: language) else { return nil }
        queries[language] = compiled
        return compiled
    }

    /// Throwing path lets package tests report malformed resources precisely.
    func compileQuery(for id: TreeSitterLanguage) throws -> Query? {
        switch id {
        case .agda, .julia, .perl, .verilog, .plainText: return nil
        default: break
        }
        guard let entry = CodeLanguage.allLanguages.first(where: { $0.id == id }),
              let language = entry.language else { return nil }
        var resources: [(String, String)] = []
        if id == .cpp || id == .objc { resources.append(("c", "highlights")) }
        if id == .typescript || id == .tsx { resources.append(("javascript", "highlights")) }
        resources.append((entry.tsName, "highlights"))
        if id == .jsx || id == .tsx { resources.append(("javascript", "highlights-jsx")) }
        if entry.additionalHighlights?.contains("injections") == true {
            resources.append((entry.tsName, "injections"))
        }
        let text = try resources.map { directory, name in
            guard let url = CodeLanguage.queryResource(directory, name) else {
                throw CocoaError(.fileNoSuchFile, userInfo: [NSFilePathErrorKey: "\(directory)/\(name).scm"])
            }
            return try String(contentsOf: url, encoding: .utf8)
        }.joined(separator: "\n")
        return try Query(language: language, data: Data(text.utf8))
    }
}
