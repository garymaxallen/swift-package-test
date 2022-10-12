// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "MySwift",
  products: [
    .executable(name: "MySwift", targets: ["MySwift"])
  ],
  targets: [
    .executableTarget(
      name: "MySwift",
      dependencies: [
        .target(name: "MyPoint")
      ]
    ),
    .target(
      name: "MyPoint"
    ),
  ]
)
