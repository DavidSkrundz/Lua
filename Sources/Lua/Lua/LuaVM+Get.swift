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
	
	/// Convert the item at `Index` to a pointer
	///
	/// - Returns: Either a pointer to the `UserData`, `LightUserData` or `nil`
	public func getUserData(atIndex index: Index) -> UnsafeMutableRawPointer? {
		return lua_touserdata(self.state, index)
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
	
	/// Create a new empty `Table` and push it onto the stack
	///
	/// - Parameter size: An estimate of how many elements the table will have
	///                   as a sequence
	/// - Parameter count: An estimate of how many other elements the table will
	///                    have
	internal func createTable(size: Count, count: Count) {
		lua_createtable(self.state, size, count)
	}
	
	/// Create a new table, add it to the registry with key `name` and push it
	/// onto the stack
	///
	/// - Throws: `LuaError.TypeCreation` if the key is already in use
	internal func createMetatable(name: String) throws {
		guard luaL_newmetatable(self.state, name) == 1 else {
			throw LuaError.TypeCreation("Metatable with name '\(name)' already exists")
		}
	}
	
	/// Allocate a new block of memory of `size` bytes, and push a full userdata 
	/// onto the stack
	///
	/// - Parameter size: The size of the block in bytes
	///
	/// - Returns: A pointer to the new block of memory
	internal func createUserData(size: Int) -> UnsafeMutableRawPointer {
		return lua_newuserdata(self.state, size)!
	}
}
