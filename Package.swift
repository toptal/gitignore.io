// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "GitignoreIO",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor"]),
        .target(name: "GitignoreIOServer", dependencies: ["App"])
    ]
)
