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

func AssertEqual(_ lhs: Value, _ rhs: Value,
                 file: StaticString = #file, line: UInt = #line) {
	if !equal(lhs, rhs) {
		XCTFail("\(lhs) is not equal to \(rhs)", file: file, line: line)
	}
}

func AssertNotEqual(_ lhs: Value, _ rhs: Value,
                    file: StaticString = #file, line: UInt = #line) {
	if equal(lhs, rhs) {
		XCTFail("\(lhs) is not equal to \(rhs)", file: file, line: line)
	}
}

func AssertEqual(_ lhs: [Value], _ rhs: [Value],
                 file: StaticString = #file, line: UInt = #line) {
	if lhs != rhs {
		XCTFail("\(lhs) is not equal to \(rhs)", file: file, line: line)
	}
}
