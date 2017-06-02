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
}
