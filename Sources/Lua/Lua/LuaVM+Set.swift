//
//  LuaVM+Set.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Does `T[k] = v` where `T` is the table at `Index`, `v` is value at the
	/// top of the stack, and `k` is the value below `v`
	///
	/// Pops both `k` and `v` off the stack
	internal func setTable(atIndex index: Index) {
		lua_settable(self.state, index)
	}
	
	/// Pop a table from the stack and set it as the new metatable for the
	/// value at `Index`
	internal func setMetatable(atIndex index: Index) {
		lua_setmetatable(self.state, index)
	}
	
	/// Set the metatable for the object at the top of the stack to the
	/// metatable at the given `name`
	internal func setMetatable(name: String) {
		luaL_setmetatable(self.state, name)
	}
}
