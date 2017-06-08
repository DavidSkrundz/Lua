//
//  LuaVM.swift
//  Lua
//

import CLua

/// The raw Thread of a Lua Virtual Machine
///
/// Provides direct access to the C API
public final class LuaVM {
	public static let versionString = LUA_VERSION_RELEASE
	public static let majorVersion = Int(LUA_VERSION_MAJOR)!
	public static let minorVersion = Int(LUA_VERSION_MINOR)!
	public static let patchVersion = Int(LUA_VERSION_RELEASE)!
	
	private let shouldDeinit: Bool
	internal let state: OpaquePointer!
	
	/// Create a new LuaVM with the default memory allocator
	internal init() {
		self.shouldDeinit = true
		self.state = luaL_newstate()
	}
	
	/// Create a new LuaVM from a lua_state pointer
	///
	/// - Parameter state: The state pointer
	internal init(state: OpaquePointer!) {
		self.shouldDeinit = false
		self.state = state
	}
	
	deinit {
		if self.shouldDeinit {
			lua_close(self.state)
		}
	}
}
