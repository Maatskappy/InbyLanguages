#!/bin/bash
set -euo pipefail
package_root=$(cd "$(dirname "$0")/.." && pwd)
consumer="$package_root/.build/versioned-consumer"
tag="0.0.0-consumer-check"
mkdir -p "$consumer/Sources/Consumer"
git -C "$package_root" tag "$tag" HEAD
trap 'git -C "$package_root" tag -d "$tag" >/dev/null' EXIT
cat > "$consumer/Package.swift" <<SWIFT
// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "Consumer",
    platforms: [.macOS(.v13)],
    dependencies: [.package(url: "file://$package_root", exact: "$tag")],
    targets: [.executableTarget(name: "Consumer", dependencies: [
        .product(name: "InbyLanguages", package: "InbyLanguages"),
        .product(name: "TreeSitterJSON", package: "InbyLanguages")
    ])]
)
SWIFT
cat > "$consumer/Sources/Consumer/main.swift" <<'SWIFT'
import InbyLanguages
import TreeSitterJSON
precondition(tree_sitter_json() != nil)
precondition(TreeSitterModel.shared.query(for: .json) != nil)
SWIFT
swift run --package-path "$consumer" Consumer
