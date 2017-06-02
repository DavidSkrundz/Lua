//
//  LuaVM+Get.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Convert the item at `Index` to a `String`
	///
	/// Cannot contain embedded zeros
	///
	/// - Note: If the value is a number, then the actual value in the stack is
	///         changed to a string.
	///
	/// - Returns: A `String` or `nil` if the value is not convertible
	public func getString(atIndex index: Index) -> String? {
		var length = 0
		guard let cstring = lua_tolstring(self.state, index, &length) else {
			return nil
		}
		return String(cString: cstring)
	}
}
