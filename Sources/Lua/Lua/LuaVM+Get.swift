//
//  LuaVM+Get.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Convert the item at `Index` to a `Double`
	///
	/// - Returns: A `Double` or `nil` if the value is not convertible
	public func getDouble(atIndex index: Index) -> Double? {
		var isNumber: Index = 0
		let value = lua_tonumberx(self.state, index, &isNumber)
		return (isNumber == 1) ? value : nil
	}
	
	/// Convert the item at `Index` to an `Int`
	///
	/// - Returns: An `Int` or `nil` if the value is not convertible
	public func getInt(atIndex index: Index) -> Int? {
		var isInteger: Index = 0
		let value = lua_tointegerx(self.state, index, &isInteger)
		return (isInteger == 1) ? value : nil
	}
	
	/// Convert the item at `Index` to a UInt32
	///
	/// - Returns: A `UInt32` or `nil` if the value is not convertible
	public func getUInt(atIndex index: Index) -> UInt32? {
		var isUInteger: Index = 0
		let value = lua_tounsignedx(self.state, index, &isUInteger)
		return (isUInteger == 1) ? value : nil
	}
	
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

extension LuaVM {
	/// Push onto the stack the value `T[k]` where `T` is the table at `index`
	/// and `k` is the top value of the stack
	///
	/// May trigger a metamethod for the "index" event
	///
	/// - Note: The top value of the stack is replaced by the result
	///
	/// - Parameter index: The `Index` of the table on the stack
	public func getTable(atIndex index: Index) {
		lua_gettable(self.state, index)
	}
	
	/// Push onto the stack the value `T[field]` where `T` is the `Table` at
	/// `Index`
	///
	/// Does not use metamethods
	/// 
	/// - Parameter field: The `Index` of the `Table` that should be fetched
	/// - Parameter index: The `Index` on the stack of the `Table` to fetch from
	internal func getFieldRaw(_ field: Index, atIndex index: Index) {
		lua_rawgeti(self.state, index, field)
	}
}
