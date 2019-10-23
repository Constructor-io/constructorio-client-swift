// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "ConstructorIO",
    path: "AutocompleteClient/",
    products: [
        .library(name: "ConstructorAutocomplete", targets: ["AutocompleteClient"])
    ],
    targets: [
        .target(name: "AutocompleteClient")
    ]
)
