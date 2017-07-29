//
//  Function.swift
//  Lua
//

/// Represent a function within Lua
public final class Function {
	private let lua: Lua
	internal let reference: Reference
	
	public var hashValue: Int {
		return Int(self.reference.rawValue)
	}
	
	/// Create a new `Function` by popping the top value from the stack
	internal init(lua: Lua) {
		self.lua = lua
		self.reference = self.lua.popWithReference()
	}
	
	deinit {
		self.lua.release(self.reference)
	}
	
	/// Perform equality between two `Function`s
	///
	/// - Parameter rhs: The `Function` to compare to
	///
	/// - Returns: `true` if the `Function`s are the same object
	fileprivate func isEqual(to other: Function) -> Bool {
		self.lua.push(value: self)
		self.lua.push(value: other)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: TopIndex, index2: SecondIndex,
		                            comparator: .Equal)
	}
	
	/// Call `self` with the given arguments
	///
	/// - Parameter arguments: The arguments to pass to the function
	///
	/// - Throws: `LuaError.Runtime`, `LuaError.MessageHandler`, or
	///           `LuaError.GarbageCollector` depending on the error
	///
	/// - Returns: The `[Value]` returned by the function
	public func call(_ arguments: [Value]) throws -> [Value] {
		return try self.lua.call(function: self, arguments: arguments)
	}
}

extension Function: Equatable {}

public func ==(lhs: Function, rhs: Function) -> Bool {
	return lhs.isEqual(to: rhs)
}
