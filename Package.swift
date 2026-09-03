// swift-tools-version: 6.4
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-histomorphism-derivation",
    products: [
        .library(name: "Histomorphism Derivation", targets: ["Histomorphism Derivation"]),
        .library(name: "Histomorphism Derivation Core", targets: ["Histomorphism Derivation Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-cofree-derivation.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-recursive-derivation.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(name: "Histomorphism Derivation Core", dependencies: [
            .product(name: "Cofree Derivation Core", package: "swift-cofree-derivation"),
            .product(name: "Recursive Derivation Core", package: "swift-recursive-derivation"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .macro(name: "Histomorphism Derivation Macros", dependencies: [
            "Histomorphism Derivation Core",
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        ]),
        .target(name: "Histomorphism Derivation", dependencies: ["Histomorphism Derivation Macros"]),
        .testTarget(
            name: "Histomorphism Derivation Tests",
            dependencies: ["Histomorphism Derivation"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
