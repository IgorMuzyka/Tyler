// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tyler",
    products: [
        .library(name: "Tyler", targets: ["Tyler"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IgorMuzyka/Tyler.Tag", .branch("master")),
        .package(url: "https://github.com/IgorMuzyka/Tyler.Variable", .branch("master")),
        .package(url: "https://github.com/IgorMuzyka/Tyler.Identifier", .branch("master")),
        .package(url: "https://github.com/IgorMuzyka/Tyler.Style", .branch("master")),
        .package(url: "https://github.com/IgorMuzyka/Tyler.Anchor", .branch("master")),
        .package(url: "https://github.com/IgorMuzyka/Tyler.Action", .branch("master")),
    ],
    targets: [
        .target(
            name: "Tyler",
            dependencies: [
                "Tyler.Tag",
                "Tyler.Variable",
                "Tyler.Style",
                "Tyler.Identifier",
                "Tyler.Anchor",
                "Tyler.Action",
            ]
        ),
    ]
)
