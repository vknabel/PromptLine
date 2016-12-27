import PackageDescription

let package = Package(
    name: "PromptLine",
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3),
        .Package(url: "https://github.com/vknabel/Lens.git", majorVersion: 0, minor: 1),
    ]
)
