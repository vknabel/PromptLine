import PackageDescription

let package = Package(
    name: "PromptLine",
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/antitypical/Result", majorVersion: 3),
        .Package(url: "https://github.com/vknabel/Lens", majorVersion: 0, minor: 1),
    ]
)
