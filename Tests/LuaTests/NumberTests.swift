//
//  NumberTests.swift
//  Lua
//

import Lua
import XCTest

class NumberTests: XCTestCase {
	func testReturnNumber() {
		do {
			let lua = Lua()
			let results = try lua.run("return 5")
			AssertEqual(results, [5])
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
			AssertEqual(results, [0, -34])
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
		XCTAssertTrue(five.isInt)
		XCTAssertTrue(eight.isInt)
		XCTAssertTrue(five2.isInt)
		XCTAssertFalse(five != five2)
		XCTAssertFalse(five >= eight)
		XCTAssertFalse(5 != five2)
		XCTAssertFalse(7 >= eight)
		XCTAssertFalse(eight != 8)
		XCTAssertFalse(five >= 8)
		XCTAssertTrue(five > 2)
		XCTAssertTrue(9 > five)
	}
	
	func testNumberUIntComparison() {
		let lua = Lua()
		lua.push(value: UInt32(5))
		lua.push(value: UInt32(8))
		let eight = lua.pop() as! Number
		let five = lua.pop() as! Number
		lua.push(value: five)
		let five2 = lua.pop() as! Number
		XCTAssertTrue(five.isInt)
		XCTAssertTrue(eight.isInt)
		XCTAssertTrue(five2.isInt)
		XCTAssertFalse(five != five2)
		XCTAssertFalse(five >= eight)
		XCTAssertTrue(five <= eight)
		XCTAssertFalse(UInt32(5) != five2)
		XCTAssertFalse(UInt32(7) >= eight)
		XCTAssertFalse(eight != UInt32(8))
		XCTAssertFalse(five >= UInt32(8))
		XCTAssertTrue(five > UInt32(2))
		XCTAssertTrue(UInt32(6) > five)
	}
	
	func testNumberDoubleComparison() {
		let lua = Lua()
		lua.push(value: 5.3)
		lua.push(value: 8.8)
		let eight = lua.pop() as! Number
		let five = lua.pop() as! Number
		lua.push(value: five)
		let five2 = lua.pop() as! Number
		XCTAssertFalse(five.isInt)
		XCTAssertFalse(eight.isInt)
		XCTAssertFalse(five2.isInt)
		XCTAssertFalse(five != five2)
		XCTAssertFalse(five >= eight)
		XCTAssertFalse(5.3 != five2)
		XCTAssertFalse(7.1 >= eight)
		XCTAssertFalse(eight != 8.8)
		XCTAssertFalse(five >= 8.8)
		XCTAssertTrue(five > 2.6)
		XCTAssertTrue(5.3001 > five)
	}
	
	func testNumberConversion() {
		do {
			let lua = Lua()
			let number = try lua.run("return -4.3")[0] as! Number
			XCTAssertFalse(number.isInt)
			XCTAssertEqual(number.intValue, Int(-4))
			XCTAssertEqual(number.uintValue, UInt32(bitPattern: Int32(-4)))
			XCTAssertEqual(number.doubleValue, Double(-4.3))
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testConvertedNumber() {
		let lua = Lua()
		lua.push(value: Int(-1000))
		let number = lua.pop() as! Number
		lua.push(value: number.uintValue)
		let number2 = lua.pop() as! Number
		XCTAssertEqual(number2.doubleValue, 4294966296.0)
	}
	
	static var allTests = [
		("testReturnNumber", testReturnNumber),
		("testMultipleReturnNumbers", testMultipleReturnNumbers),
		("testNumberIntComparison", testNumberIntComparison),
		("testNumberUIntComparison", testNumberUIntComparison),
		("testNumberDoubleComparison", testNumberDoubleComparison),
		("testNumberConversion", testNumberConversion),
		("testConvertedNumber", testConvertedNumber),
	]
}
