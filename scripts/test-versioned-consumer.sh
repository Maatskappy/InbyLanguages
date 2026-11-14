#!/bin/bash
set -euo pipefail
package_root=$(cd "$(dirname "$0")/.." && pwd)
consumer="$package_root/.build/versioned-consumer"
tag="0.0.0-consumer-check"
mkdir -p "$consumer/Sources/Consumer"
repository="$consumer/InbyLanguages.git"
if [ ! -d "$repository" ]; then
    git clone --bare --shared "$package_root" "$repository"
fi
git --git-dir="$repository" fetch "$package_root" HEAD
git --git-dir="$repository" tag -f "$tag" FETCH_HEAD
cat > "$consumer/Package.swift" <<SWIFT
// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "Consumer",
    platforms: [.macOS(.v13)],
    dependencies: [.package(url: "file://$repository", exact: "$tag")],
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
