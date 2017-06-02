//
//  NumberTests.swift
//  Lua
//

@testable import Lua
import XCTest

class NumberTests: XCTestCase {
	func testReturnNumber() {
		do {
			let lua = Lua()
			let results = try lua.run("return 5")
			AssertEqual(lhs: results, rhs: [5])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testMultipleReturnNumbers() {
		do {
			let lua = Lua()
			let results = try lua.run("return 0, -34")
			AssertEqual(lhs: results, rhs: [0, -34])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	static var allTests = [
		("testReturnNumber", testReturnNumber),
		("testMultipleReturnNumbers", testMultipleReturnNumbers),
	]
}
