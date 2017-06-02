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
	public func pop(_ count: Count) {
		precondition(count >= 0)
		lua_settop(self.state, -count - 1)
	}
	
	/// Push a copy of the element at `Index` to the top of the stack
	///
	/// - Parameter index: The index of the element to copy
	public func pushValue(atIndex index: Index) {
		lua_pushvalue(self.state, index)
	}
}
