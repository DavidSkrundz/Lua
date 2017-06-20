//
//  Lua+Code.swift
//  Lua
//

import Foundation

extension Lua {
	/// Run a `String` of Lua code as a `Function` that takes no arguments
	///
	/// - Parameter code: The Lua code to run
	///
	/// - Throws: `LuaError.Syntax`, `LuaError.Runtime`,
	///           `LuaError.MessageHandler`, `LuaError.GarbageCollector`
	///           depending on the error
	///
	/// - Returns: Any `Value`s returned by the Lua code
	public func run(_ code: String) throws -> [Value] {
		let originalStackSize = self.raw.stackSize()
		try self.raw.load(code: code)
		try self.raw.protectedCall(nargs: 0, nrets: MultipleReturns)
		return self.popValues(toSize: originalStackSize)
	}
	
	/// Run a Lua file as a `Function` that takes not arguments
	///
	/// - Parameter path: A `URL` to the file
	///
	/// - Throws: `LuaError.Syntax`, `LuaError.GarbageCollector`, or
	///           `LuaError.IO` depending on the error
	///
	/// - Returns: Any `Value`s returned by the Lua code
	public func run(file: URL) throws -> [Value] {
		let originalStackSize = self.raw.stackSize()
		try self.raw.load(file: file)
		try self.raw.protectedCall(nargs: 0, nrets: MultipleReturns)
		return self.popValues(toSize: originalStackSize)
	}
	
	/// Call a `Function` with the provided arguments
	///
	/// - Parameter function: The `Function` to call
	/// - Parameter arguments: A list of arguments to pass
	///
	/// - Throws: `LuaError.Runtime`, `LuaError.MessageHandler`, or
	///           `LuaError.GarbageCollector` depending on the error
	///
	/// - Returns: The `[Value]` returned by the function
	internal func call(function: Function,
	                 arguments: [Value] = []) throws -> [Value] {
		let originalStackSize = self.raw.stackSize()
		self.push(value: function)
		arguments.forEach { self.push(value: $0) }
		try self.raw.protectedCall(nargs: Count(arguments.count),
		                           nrets: MultipleReturns)
		return self.popValues(toSize: originalStackSize)
	}
}
