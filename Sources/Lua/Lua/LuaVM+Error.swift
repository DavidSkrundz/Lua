//
//  LuaVM+Error.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Generates a Lua error
	public func error(_ message: String) -> Never {
		self.push(message)
		_ = lua_error(self.state)
		fatalError("Will never get called")
	}
}
