// swift-tools-version:3.1
//
//  Package.swift
//  Lua
//

import PackageDescription

let package = Package(
	name: "Lua",
	dependencies: [
		.Package(url: "https://github.com/DavidSkrundz/CLua.git", majorVersion: 5, minor: 2),
	]
)

let staticLibrary = Product(
	name: "Lua",
	type: .Library(.Static),
	modules: ["Lua"]
)
let dynamicLibrary = Product(
	name: "Lua",
	type: .Library(.Dynamic),
	modules: ["Lua"]
)

products.append(staticLibrary)
products.append(dynamicLibrary)
