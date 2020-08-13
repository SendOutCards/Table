// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Table",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Table", targets: ["Table"]),
    ],
    dependencies: [
        .package(url: "https://github.com/devicekit/DeviceKit.git", .upToNextMajor(from: "3.2.0")),
    ],
    targets: [
        .target(name: "CYoga"),
        .target(name: "Table", dependencies: ["DeviceKit", "CYoga"]),
        .testTarget(name: "TableTests", dependencies: ["Table"]),
    ]
)
