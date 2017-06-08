//
//  Function.swift
//  Lua
//

/// Represent a function within Lua
public final class Function {
	private let lua: Lua
	internal let reference: Reference
	
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
}

extension Function: Equatable {}

public func ==(lhs: Function, rhs: Function) -> Bool {
	return lhs.isEqual(to: rhs)
}
