import PackageDescription

let package = Package(
    name: "GitignoreIO",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 1)
    ],
    exclude: [
        "Config",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)
