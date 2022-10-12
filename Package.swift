// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "MySwift",
  products: [
    .executable(name: "MySwift", targets: ["MySwift"])
  ],
  dependencies: [],
  targets: [
    .executableTarget(
      name: "MySwift",
      dependencies: [
        .target(name: "MyC")
      ]
    ),
    .target(
      name: "MyC"
    ),
  ]
)
