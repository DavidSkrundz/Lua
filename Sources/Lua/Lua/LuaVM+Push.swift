//
//  LuaVM+Push.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Push an `Int` onto the stack
	public func push(_ value: Int) {
		lua_pushinteger(self.state, value)
	}
}
