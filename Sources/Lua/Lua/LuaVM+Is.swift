//
//  LuaVM+Is.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Check the type of the top item on the stack
	///
	/// - Returns: The `Type` of the value at `Index`
	public func type(atIndex index: Index) -> Type {
		return Type(rawValue: lua_type(self.state, index))
	}
}
