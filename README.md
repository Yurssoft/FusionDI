# FusionDI

**FusionDI** is a lightweight Swift dependency injection library designed to offer a simple and easy-to-use interface for resolving dependencies in your project. This library aims to keep the core functionality minimal while allowing users to inject and manage dependencies in a clean and efficient way.

## Features

- Easy to integrate into existing projects.
- Simple API for registering and resolving services.
- Lightweight and minimalistic, ideal for small projects or learning purposes.

## Installation

To integrate **FusionDI** into your Xcode project using Swift Package Manager, add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Yurssoft/FusionDI", from: "1.0.0")
]
```

## Usage

### Registering Dependencies

You can register a service and its implementation using the following syntax:

```swift
ServiceResolver.shared.register { YourServiceImplementation() as YourServiceProtocol }
```

### Resolving Dependencies

Once a service is registered, you can resolve it anywhere in your project:

```swift
let service = ServiceResolver.shared.resolve(YourServiceProtocol.self)
```

## Note

**Scope features** such as singleton or transient instances were intentionally left out to keep the library simple and straightforward. This library is perfect for smaller projects or for developers who want to experiment with dependency injection without extra complexity.

## For more sophisticated solutions, consider the following libraries: 
- [Swinject](https://github.com/Swinject/Swinject)
- [Resolver](https://github.com/hmlongco/Resolver)
- [Factory](https://github.com/hmlongco/Factory)
- [Weaver](https://github.com/scribd/Weaver)
- [Needle](https://github.com/uber/needle)

## License

FusionDI is released under the MIT license. See [LICENSE](./LICENSE) for details.
