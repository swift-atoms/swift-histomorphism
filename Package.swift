// swift-tools-version: 6.4
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-histomorphism",
    products: [
        .library(name: "Histomorphism Macro", targets: ["Histomorphism Macro"]),
        .library(name: "Histomorphism Macro Core", targets: ["Histomorphism Macro Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-cofree.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-recursive.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(name: "Histomorphism Macro Core", dependencies: [
            .product(name: "Cofree Macro Core", package: "swift-cofree"),
            .product(name: "Recursive Macro Core", package: "swift-recursive"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .macro(name: "Histomorphism Macro Plugin", dependencies: [
            "Histomorphism Macro Core",
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        ]),
        .target(name: "Histomorphism Macro", dependencies: ["Histomorphism Macro Plugin"]),
        .testTarget(
            name: "Histomorphism Macro Tests",
            dependencies: ["Histomorphism Macro"]
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
