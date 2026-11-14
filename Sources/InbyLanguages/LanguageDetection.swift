import Foundation

public extension CodeLanguage {
    /// Detect by filename first, then a shebang or modeline in the supplied text.
    static func detectLanguageFrom(
        url: URL, prefixBuffer: String? = nil, suffixBuffer: String? = nil
    ) -> CodeLanguage {
        let key = url.pathExtension.isEmpty ? url.lastPathComponent : url.pathExtension.lowercased()
        if let found = allLanguages.first(where: { $0.extensions.contains(key) }) { return found }
        if let firstLine = prefixBuffer?.components(separatedBy: .newlines).first,
           firstLine.hasPrefix("#!"), let found = fromShebang(firstLine) { return found }
        for text in [prefixBuffer, suffixBuffer].compactMap({ $0 }) {
            for pattern in [#"-\*-.*?mode:\s*([\w+-]+).*?-\*-"#, #"\bvim:.*?\bft=([\w+-]+)"#] {
                if let expression = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
                   let match = expression.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
                   let range = Range(match.range(at: 1), in: text),
                   let language = fromIdentifier(String(text[range]).lowercased()) { return language }
            }
        }
        return .default
    }

    private static func fromShebang(_ line: String) -> CodeLanguage? {
        var words = line.dropFirst(2).split(whereSeparator: { $0.isWhitespace }).map(String.init)
        guard let executable = words.first else { return nil }
        var command = URL(fileURLWithPath: executable).lastPathComponent.lowercased()
        if command == "env" {
            words.removeFirst()
            guard let program = words.first(where: { !$0.hasPrefix("-") && !$0.contains("=") }) else { return nil }
            command = program.lowercased()
        }
        return fromIdentifier(command)
    }

    private static func fromIdentifier(_ identifier: String) -> CodeLanguage? {
        // Shared by shebangs and modelines, including versioned Python aliases.
        if identifier.hasPrefix("python"), identifier.dropFirst("python".count).allSatisfy({ $0.isNumber || $0 == "." }) {
            return .python
        }
        if identifier == "node" || identifier == "deno" { return .javascript }
        return allLanguages.first { $0.tsName == identifier || $0.extensions.contains(identifier) }
    }
}
