//
//  StringTests.swift
//  Lua
//

@testable import Lua
import XCTest

class StringTests: XCTestCase {
	func testReturnString() {
		do {
			let lua = Lua()
			let results = try lua.run("return \"Hello\"")
			AssertEqual(lhs: results, rhs: ["Hello"])
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
			AssertEqual(lhs: results, rhs: ["Hello", "Wow"])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	static var allTests = [
		("testReturnString", testReturnString),
		("testMultipleReturnStrings", testMultipleReturnStrings),
	]
}
