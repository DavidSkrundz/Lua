//
//  LuaTests.swift
//  Lua
//

@testable import Lua
import XCTest

class LuaTests: XCTestCase {
	func testLua() {
		let lua = Lua()
		XCTAssertEqual(lua.raw.stackSize(), 0)
	}
	
	static var allTests = [
		("testLua", testLua),
	]
}
