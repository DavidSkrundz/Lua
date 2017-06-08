//
//  FunctionTests.swift
//  Lua
//

@testable import Lua
import XCTest

class FunctionTests: XCTestCase {
	func testRawFunction() {
		let lua = Lua()
		lua.raw.load(function: { (state) -> Count in
			let lua = Lua(raw: LuaVM(state: state))
			let a = lua.pop() as! Number
			let b = lua.pop() as! Number
			lua.push(value: a.intValue + b.intValue)
			return 1
		}, valueCount: 0)
		lua.push(value: 5)
		lua.push(value: 10)
		try! lua.raw.protectedCall(nargs: 2, nrets: 1)
		XCTAssert(lua.pop() == 15)
	}
	
	func testFunction() {
		do {
			let lua = Lua()
			let addFunc = lua.createFunction { (lua) -> [Value] in
				XCTAssertEqual(lua.raw.stackSize(), 2)
				let a = (lua.pop() as! Number).intValue
				let b = (lua.pop() as! Number).intValue
				return [a + b]
			}
			let values = try lua.call(function: addFunc, arguments: [7, 11])
			AssertEqual(values, [18])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testEquality() {
		let lua = Lua()
		let func1 = lua.createFunction { _ in [] }
		let func2 = lua.createFunction { _ in [] }
		XCTAssertNotEqual(func1, func2)
	}
	
	static var allTests = [
		("testRawFunction", testRawFunction),
		("testFunction", testFunction),
		("testEquality", testEquality),
	]
}
