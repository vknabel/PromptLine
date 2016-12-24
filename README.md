# PromptLine

Run shell scripts out of Swift with ease.

## Usage

With PromptLine you may combine multiple runner into one.
Later you may run them against a specific Prompt.

```swift
import PromptLine

let main = >-"git clone https://github.com/krzysztofzablocki/Sourcery.git"
    %& Prompt.cd("Sourcery")
    %& >-"swift build"
    %& >-["./.debug/sourcery", sourcePath, templatesPath, outputPath]

Prompt.current % main
```

### Operators

PromptLine uses these operators:

| Operator  | Function               | Usage                                                                         |
|-----------|------------------------|-------------------------------------------------------------------------------|
| `>-`      | `prompt.run("string")` | Creates a runner out of Strings or String arrays.                             |
| `%`       | `runner(prompt)`       | Executes a runner against a prompt.                                           |
| `%&`      | `flatMap(_:_:)`        | Chains two runners. The right one will only be executed if the first succeeds.|
| `%|`      | `flatMapError(_:_:)`   | Chains two runners. The right one will only be executed if the first failed.  |
| `%>`      | `second(_:_:)`         | Chains two runners. Both will always be executed.                             |
| `%?`      | `mapError(_:_:)`       | Maps an error.                                                                |

## Installation

You may install PromptLine using the Swift Package Manager, by adding it to your dependencies.

```swift
import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .Package(url: "https://github.com/vknabel/PromptLine.git", majorVersion: 0, minor: 1),
    ]
)
```

## Author

Valentin Knabel, [@vknabel](https://twitter.com/vknabel), dev@vknabel.com

## License

PromptLine is available under the [MIT](LICENSE) license.
