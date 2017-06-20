//
//  Lua+Type.swift
//  Lua
//

extension Lua {
	/// Create a new type in Lua from a Swift type
	///
	/// - Parameter type: The Swift type to create in Lua
	///
	/// - Throws: `LuaError.TypeCreation` if the type was already registered
	///
	/// - Returns: A `CustomType<T>` that allows for the modification of the
	///            types methods or properties
	public func createType<T: LuaConvertible>(_ type: T.Type) throws -> CustomType<T> {
		return try CustomType<T>(lua: self, type: type)
	}
}
