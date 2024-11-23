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
         .package(url: "https://github.com/willonboy/ZTChain", from: "1.0.4"),
         .package(url: "https://github.com/willonboy/ZTStyle", from: "2.0.0"),
         .package(url: "https://github.com/freshOS/Stevia", from: "5.1.4"),
    ],
    targets: [
        .target(
            name: "ZTUIKit",
            dependencies: []),
    ],
    swiftLanguageVersions: [.version("5.1")]
)
