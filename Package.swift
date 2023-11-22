// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "BitcoinKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "BitcoinKit",
            targets: ["BitcoinKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/HEchooo/BitcoinCore.Swift.git", .exact("2.1.7")),
        .package(url: "https://github.com/HEchooo/Hodler.Swift.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/horizontalsystems/HdWalletKit.Swift.git", .upToNextMinor(from: "1.2.1")),
        .package(url: "https://github.com/HEchooo/HsToolKit.Swift.git", .upToNextMajor(from: "2.0.6")),
    ],
    targets: [
        .target(
            name: "BitcoinKit",
            dependencies: [
                .product(name: "BitcoinCore", package: "BitcoinCore.Swift"),
                .product(name: "Hodler", package: "Hodler.Swift"),
                .product(name: "HdWalletKit", package: "HdWalletKit.Swift"),
                .product(name: "HsToolKit", package: "HsToolKit.Swift"),
            ]
        ),
    ]
)
