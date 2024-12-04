// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoviesScheduleInfrastructure",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MoviesScheduleInfrastructure",
            targets: ["MoviesScheduleInfrastructure"]),
    ],
    dependencies: [
        .package(name: "MoviesScheduleDomain", path: "../MoviesScheduleDomain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MoviesScheduleInfrastructure",
            dependencies: [
                "MoviesScheduleDomain"
            ],
            resources: [
                Resource.copy("JsonFiles")
            ]
        ),
        .testTarget(
            name: "MoviesScheduleInfrastructureTests",
            dependencies: ["MoviesScheduleInfrastructure"],
            resources: [
                Resource.copy("JsonFiles")
            ]
        ),
    ]
)
