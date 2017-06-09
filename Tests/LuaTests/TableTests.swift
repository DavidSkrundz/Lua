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
	
	func testCreateTable() {
		do {
			let lua = Lua()
			let table = lua.createTable()
			table["count"] = 8
			lua.globals["data"] = table
			let results = try lua.run("return data.count")
			AssertEqual(results, [8])
			XCTAssertEqual(lua.raw.stackSize(), 0)
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	static var allTests = [
		("testAccessGlobals", testAccessGlobals),
		("testEquality", testEquality),
		("testCreateTable", testCreateTable),
	]
}
