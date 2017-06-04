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
	
	func testNumberIntComparison() {
		let lua = Lua()
		lua.push(value: 5)
		lua.push(value: 8)
		let eight = lua.pop() as! Number
		let five = lua.pop() as! Number
		lua.push(value: five)
		let five2 = lua.pop() as! Number
		XCTAssertTrue(five == five2)
		XCTAssertTrue(five < eight)
		XCTAssertTrue(5 == five2)
		XCTAssertTrue(7 < eight)
		XCTAssertTrue(eight == 8)
		XCTAssertTrue(five < 8)
	}
	
	func testNumberConversion() {
		do {
			let lua = Lua()
			guard let number = try lua.run("return -4.3").first as? Number else {
				XCTFail()
				return
			}
			XCTAssertEqual(number.intValue, Int(-4))
			XCTAssertEqual(number.uintValue, UInt32(bitPattern: Int32(-4)))
			XCTAssertEqual(number.doubleValue, Double(-4.3))
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	static var allTests = [
		("testReturnNumber", testReturnNumber),
		("testMultipleReturnNumbers", testMultipleReturnNumbers),
		("testNumberIntComparison", testNumberIntComparison),
		("testNumberConversion", testNumberConversion),
	]
}
