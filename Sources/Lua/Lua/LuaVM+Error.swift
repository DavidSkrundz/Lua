//
//  LuaVM+Error.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Generates a Lua error
	internal func error(_ message: String) -> Never {
		self.push(message)
		_ = lua_error(self.state)
		fatalError("Will never get called")
	}
	
	/// Generate a Lua error for an argument `Index` with an additional
	/// `message`
	///
	/// - Parameter index: The argument's `Index`
	/// - Parameter message: An additional message to include as a comment
	internal func argumentError(_ index: Index, _ message: String) -> Never {
		_ = luaL_argerror(self.state, index, message)
		fatalError("Will never get called")
	}
}
