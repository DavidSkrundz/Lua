//
//  StringTests.swift
//  Lua
//

import Lua
import Foundation
import XCTest

class StringTests: XCTestCase {
	func testReturnString() {
		do {
			let lua = Lua()
			let results = try lua.run("return \"Hello\"")
			AssertEqual(results, ["Hello"])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testMultipleReturnStrings() {
		do {
			let lua = Lua()
			let results = try lua.run("return \"Hello\", \"Wow\"")
			AssertEqual(results, ["Hello", "Wow"])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testReturnStringFromFile() {
		CDToProjectDirectory()
		do {
			let lua = Lua()
			let filePath = URL(fileURLWithPath: "Tests/testfile.lua")
			let results = try lua.run(file: filePath)
			AssertEqual(results, ["Wowo"])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	static var allTests = [
		("testReturnString", testReturnString),
		("testMultipleReturnStrings", testMultipleReturnStrings),
		("testReturnStringFromFile", testReturnStringFromFile),
	]
}
