//
//  UserDataTests.swift
//  Lua
//

@testable import Lua
import XCTest

class UserDataTests: XCTestCase {
	func testLightUserData() {
		let lua = Lua()
		lua.raw.push(UnsafeMutablePointer(bitPattern: 3)!)
		lua.raw.push(UnsafeMutablePointer(bitPattern: 5)!)
		lua.raw.push(UnsafeMutablePointer(bitPattern: 5)!)
		
		let lud1 = lua.pop()
		let lud2 = lua.pop()
		let lud3 = lua.pop()
		
		XCTAssertTrue(lud1 == lud2)
		XCTAssertFalse(lud1 == lud3)
		XCTAssertFalse(lud2 == lud3)
		XCTAssertEqual(lua.raw.stackSize(), 0)
	}
	
	static var allTests = [
		("testLightUserData", testLightUserData),
	]
}
