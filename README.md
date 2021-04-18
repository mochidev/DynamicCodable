# DynamicCodable

<p align="center">
<a href="https://swiftpackageindex.com/mochidev/DynamicCodable">
<img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmochidev%2FDynamicCodable%2Fbadge%3Ftype%3Dswift-versions" />
</a>
<a href="https://swiftpackageindex.com/mochidev/DynamicCodable">
<img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmochidev%2FDynamicCodable%2Fbadge%3Ftype%3Dplatforms" />
</a>
<a href="https://github.com/mochidev/DynamicCodable/actions?query=workflow%3A%22Test+DynamicCodable%22">
<img src="https://github.com/mochidev/DynamicCodable/workflows/Test%20DynamicCodable/badge.svg" alt="Test Status" />
</a>
</p>

`DynamicCodable` aims to make it easy to preserve arbitrary `Codable` data structures when unarchiving, allowing you to inspect those structures in a type safe way after the decoding is finished.

## Installation

Add `DynamicCodable` as a dependency in your `Package.swift` file to start using it. Then, add `import DynamicCodable` to any file you wish to use the library in.

Please check the [releases](https://github.com/mochidev/DynamicCodable/releases) for recommended versions.

```swift
dependencies: [
    .package(url: "https://github.com/mochidev/DynamicCodable.git", .upToNextMinor(from: "1.0.0")),
],
...
targets: [
    .target(
        name: "MyPackage",
        dependencies: [
            "DynamicCodable",
        ]
    )
]
```

## What is `DynamicCodable`?

`DynamicCodable` is an enumeration that represents the various primitive types that are themselves codable. Using it is easy — simply mark the portion of your graph as being of type `DynamicCodable` to enable that subtree to be preserved during decoding:

```swift
struct ServerResponse: Codable {
    let status: String
    let metadata: DynamicCodable
}

let response = try JSONDecoder().decode(ServerResponse.self, from: data)

// Consume the metadata whole
print(response.metadata)

// Dig into the metadata — it's just an enum!
switch response.metadata {
case .keyed(let dictionary)
    print(dictionary["debugInfo"], default: .empty) // Convenience for dictionary[.string("debugInfo"), default: .empty]
case .bool(false):
    print("Metadata disabled")
case .nil:
    print("Metadata unavailable")
default: break
}
```

Note that `DynamicCodable` is not limited to be used with JSON coders - it can be used with any `Codable`-compatible coder!

## Contributing

Contribution is welcome! Please take a look at the issues already available, or start a new issue to discuss a new feature. Although guarantees can't be made regarding feature requests, PRs that fit with the goals of the project and that have been discussed before hand are more than welcome!

Please make sure that all submissions have clean commit histories, are well documented, and thoroughly tested. **Please rebase your PR** before submission rather than merge in `main`. Linear histories are required.
