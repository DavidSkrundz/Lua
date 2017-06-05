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
}
