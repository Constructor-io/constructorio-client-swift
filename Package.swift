// swift-tools-version:3.1
import PackageDescription

let package = Package(
    name: "ConstructorIO",
    products: [
        .library(name: "ConstructorAutocomplete", targets: ["AutocompleteClient"])
    ],
    targets: [
        .target(name: "AutocompleteClient")
    ]
)
