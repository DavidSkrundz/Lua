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

func AssertEqual(lhs: [Value], rhs: [Value],
                 file: StaticString = #file, line: UInt = #line) {
	if lhs != rhs {
		XCTFail("\(lhs) is not equal to \(rhs)", file: file, line: line)
	}
}
