// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TKSwitcherCollection",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "TKSwitcherCollection", targets: ["TKSwitcherCollection"])
    ],
    targets: [
        .target(name: "TKSwitcherCollection"),
        .testTarget(name: "TKSwitcherCollectionTests", dependencies: ["TKSwitcherCollection"])
    ]
)
