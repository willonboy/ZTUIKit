// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ZTUIKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ZTUIKit",
            targets: ["ZTUIKit"]),
    ],
    dependencies: [
         .package(url: "https://github.com/willonboy/ZTChain", branch: "main"),
         .package(url: "https://github.com/willonboy/ZTStyle", branch: "main"),
    ],
    targets: [
        .target(
            name: "ZTUIKit",
            dependencies: ["ZTChain", "ZTStyle"]),
    ],
    swiftLanguageVersions: [.version("5.1")]
)
