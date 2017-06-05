//
//  TableTests.swift
//  Lua
//

@testable import Lua
import XCTest

class TableTests: XCTestCase {
	func testAccessGlobals() {
		do {
			let lua = Lua()
			lua.globals["a"] = 5
			_ = try lua.run("a = a + 7")
			XCTAssertTrue(lua.globals["a"] == 12)
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testEquality() {
		let lua = Lua()
		let globals = lua.globals
		lua.push(value: globals)
		let copy = lua.pop()
		XCTAssertTrue(globals == copy)
	}
	
	static var allTests = [
		("testAccessGlobals", testAccessGlobals),
		("testEquality", testEquality),
	]
}
