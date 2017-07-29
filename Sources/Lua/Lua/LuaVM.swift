//
//  LuaVM.swift
//  Lua
//

import CLua

/// The raw Thread of a Lua Virtual Machine
///
/// Provides direct access to the C API
public final class LuaVM {
	/// A `Bool` that 
	private let shouldDeinit: Bool
	
	/// A pointer to the Lua state C struct
	internal let state: OpaquePointer!
	
	/// Holds all functions that were registered
	internal var functions = [LuaFunction]()
	
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

extension LuaVM {
	/// Pop a key from the stack and push the next key-value pair from the table
	/// at `Index`
	///
	/// - Returns: `false` if there are no more pairs
	/// ```
	/// /* the table is in the stack at index 't' */
	/// lua.raw.pushNil(); /* first key */
	/// while lua.raw.next(atIndex: t) {
	///     /* 'key' (at `SecondIndex`) and 'value' (at `TopIndex`) */
	///     let value = lua.pop()
	///     /* keep 'key' for next iteration */
	/// }
	/// ```
	///
	/// - Note: While traversing a table, do not call `getString(atIndex:)`
	/// directly on a key, unless you know that the key is actually a string.
	internal func next(atIndex index: Index) -> Bool {
		return lua_next(self.state, index) != 0
	}
}
