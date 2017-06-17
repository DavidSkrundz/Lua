//
//  CustomTypeTests.swift
//  Lua
//

@testable import Lua
import XCTest

class CustomTypeTests: XCTestCase {
	func testTypeCreation() {
		do {
			let lua = Lua()
			try lua.createType(Object.self)
			let results = try lua.run("return Object.add(3.5, 8.6)")
			AssertEqual(results, [12.1])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testInstanceCreation() {
		do {
			let lua = Lua()
			try lua.createType(Object.self)
			_ = try lua.run("obj = Object.new('--suffix')")
			let instance: Object = (lua.globals["obj"] as! UserData).toType()
			XCTAssertEqual(instance.suffix, "--suffix")
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testMethodCall() {
		do {
			let lua = Lua()
			try lua.createType(Object.self)
			lua.globals["obj"] = Object(suffix: "swef")
			_ = try lua.run("oldSuffix = obj:getSuffix()")
			_ = try lua.run("obj:setSuffix('--wapoz')")
			let results = try lua.run("return obj:addSuffix(oldSuffix)")
			let instance: Object = (lua.globals["obj"] as! UserData).toType()
			AssertEqual(results, ["swef--wapoz"])
			XCTAssertEqual(instance.suffix, "--wapoz")
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	func testTypeChecking() {
		do {
			let lua = Lua()
			try lua.createType(Object.self)
			lua.globals["obj"] = Object(suffix: "suffix")
			let results = try lua.run("return Object.getSuffixFrom(obj)")
			AssertEqual(results, ["suffix"])
		} catch let e as LuaError {
			XCTFail(e.description)
		} catch let e {
			XCTFail(e.localizedDescription)
		}
	}
	
	static var allTests = [
		("testTypeCreation", testTypeCreation),
		("testInstanceCreation", testInstanceCreation),
		("testMethodCall", testMethodCall),
		("testTypeChecking", testTypeChecking),
	]
}

private final class Object: LuaConvertible {
	static var typeName: StaticString = "Object"
	
	static var initializer = Lua.wrap([.String]) { (values) -> Object in
		return Object(suffix: values[0] as! String)
	}
	
	static var functions = [
		("add", Lua.wrap([.Number, .Number]) { (values) -> [Value] in
			return [Object.add(values[0] as! Number, values[1] as! Number)]
		}),
		("getSuffixFrom", Lua.wrap([.Custom(Object.self)]) { (values) -> [Value] in
			return [(values[0] as! Object).suffix]
		}),
	]
	
	static let methods = [
		("getSuffix", Lua.wrap([]) { (obj: Object, _) -> [Value] in
			return [obj.suffix]
		}),
		("setSuffix", Lua.wrap([.String]) { (obj: Object, values) -> [Value] in
			obj.suffix = values[0] as! String
			return []
		}),
		("addSuffix", Lua.wrap([.String]) { (obj: Object, values) -> [Value] in
			return [obj.addSuffix(values[0] as! String)]
		}),
	]
	
	var suffix = ""
	
	init(suffix: String) {
		self.suffix = suffix
	}
	
	static func add(_ lhs: Number, _ rhs: Number) -> Double {
		return lhs.doubleValue + rhs.doubleValue
	}
	
	func addSuffix(_ string: String) -> String {
		return string + self.suffix
	}
}
