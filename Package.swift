// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "ConstructorIO",
    
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "ConstructorAutocomplete", targets: ["ConstructorAutocomplete"])
    ],
    targets: [
        .target(name: "ConstructorAutocomplete",
                path: "AutocompleteClient/")
    ]
)
