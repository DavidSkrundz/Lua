//
//  FunctionTests.swift
//  Lua
//

import Lua
import XCTest

class FunctionTests: XCTestCase {
	func testFunction() {
		do {
			let lua = Lua()
			let addFunc = lua.createFunction { (lua) -> [Value] in
				XCTAssertEqual(lua.raw.stackSize(), 2)
				let a = (lua.pop() as! Number).intValue
				let b = (lua.pop() as! Number).intValue
				return [a + b]
			}
			let values = try addFunc.call([7, 11])
			AssertEqual(values, [18])
			XCTAssertEqual(lua.raw.stackSize(), 0)
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testWrappedFunction() {
		do {
			let lua = Lua()
			let split = lua.createFunction([.String, .String]) { (values) -> [Value] in
				let string = values[0] as! String
				let separator = values[1] as! String
				return string.components(separatedBy: separator)
			}
			lua.globals["split"] = split
			let values = try lua.run("return split('first second', ' ')")
			AssertEqual(values, ["first", "second"])
			XCTAssertEqual(lua.raw.stackSize(), 0)
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testTypeChecker() {
		let lua = Lua()
		let stringAppend = lua.createFunction([.String, .String]) { (values) -> [Value] in
			return [(values[0] as! String) + (values[1] as! String)]
		}
		lua.globals["append"] = stringAppend
		
		do {
			let values = try lua.run("return append('one', 'two')")
			AssertEqual(values, ["onetwo"])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
		
		do {
			_ = try lua.run("return append(5, 'two')")
			XCTFail()
		} catch let LuaError.Runtime(message) {
			XCTAssertEqual(message, "[string \"return append(5, 'two')\"]:1: bad argument #1 to 'append' (string expected, got number)")
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
		XCTAssertEqual(lua.raw.stackSize(), 0)
	}
	
	func testEquality() {
		let lua = Lua()
		let func1 = lua.createFunction { _ in [] }
		let func2 = lua.createFunction { _ in [] }
		XCTAssertNotEqual(func1, func2)
	}
	
	static var allTests = [
//		("testRawFunction", testRawFunction),
		("testFunction", testFunction),
		("testWrappedFunction", testWrappedFunction),
		("testTypeChecker", testTypeChecker),
		("testEquality", testEquality),
	]
}
