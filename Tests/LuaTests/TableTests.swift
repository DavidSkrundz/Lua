//
//  TableTests.swift
//  Lua
//

import Lua
import XCTest

class TableTests: XCTestCase {
	func testAccessGlobals() {
		do {
			let lua = Lua()
			lua.globals["a"] = 5
			_ = try lua.run("a = a + 7")
			AssertEqual(lua.globals["a"], 12)
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
		AssertEqual(globals, copy)
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
	
	func testTableForEach() {
		let lua = Lua()
		let table = lua.createTable()
		table["a"] = "a"
		table[1] = 2
		
		var foundA = false
		var found1 = false
		table.forEach { (key: TableKey, value: Value) in
			if (key == TableKey("a")) {
				XCTAssertFalse(foundA)
				AssertEqual(value, "a")
				foundA = true
			} else if (key == TableKey(1)) {
				XCTAssertFalse(found1)
				AssertEqual(value, 2)
				found1 = true
			} else {
				XCTFail("Bad key, got \(key)")
			}
		}
		XCTAssertTrue(foundA)
		XCTAssertTrue(found1)
	}
	
	func testTableToDictionary() {
		let lua = Lua()
		let table = lua.createTable()
		table[1] = 1
		table[2] = 5
		table[3] = 10
		table["key"] = "value"
		table["otherKey"] = 2
		let dict = table.toDictionary()
		XCTAssertEqual(dict.count, 5)
		AssertEqual(dict[TableKey(1)]!, 1)
		AssertEqual(dict[TableKey(2)]!, 5)
		AssertEqual(dict[TableKey(3)]!, 10)
		AssertEqual(dict[TableKey("key")] ?? Nil(), "value")
		AssertEqual(dict[TableKey("otherKey")] ?? Nil(), 2)
	}
	
	static var allTests = [
		("testAccessGlobals", testAccessGlobals),
		("testEquality", testEquality),
		("testCreateTable", testCreateTable),
		("testTableForEach", testTableForEach),
		("testTableToDictionary", testTableToDictionary),
	]
}
