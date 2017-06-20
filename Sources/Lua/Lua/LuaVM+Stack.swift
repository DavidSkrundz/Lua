//
//  LuaVM+Stack.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Get the number of items on the stack (the `Index` of the topmost item)
	///
	/// - Returns: The number of items on the stack
	public func stackSize() -> Count {
		return lua_gettop(self.state)
	}
	
	/// Pop elements off the stack
	///
	/// - Precondition: `count >= 0`
	///
	/// - Parameter count: The number of elements to pop
	internal func pop(_ count: Count) {
		precondition(count >= 0)
		lua_settop(self.state, -count - 1)
	}
	
	/// Push a copy of the element at `Index` to the top of the stack
	///
	/// - Parameter index: The index of the element to copy
	internal func pushValue(atIndex index: Index) {
		lua_pushvalue(self.state, index)
	}
	
	/// Remove the element at `Index` shifting other elements down to fill the
	/// gap
	///
	/// - Precondition: `Index` is not a pseudo-index
	///
	/// - Parameter index: The index to remove
	internal func remove(atIndex index: Index) {
		lua_remove(self.state, index)
	}
}
