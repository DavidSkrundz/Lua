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
}
