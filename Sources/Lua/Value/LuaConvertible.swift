//
//  LuaConvertible.swift
//  Lua
//

/// Used as a 'super protocol' of `LuaConvertible` in order to convert
/// `LuaConvertible` objects into `UserData`s
///
/// Should not be used directly
public protocol UserDataConvertible: Value {
	/// - Returns: The name of the type that will be used in Lua
	static var typeName: StaticString { get }
}

/// Implemented by types that should be brought into Lua
public protocol LuaConvertible: UserDataConvertible, Value {
	/// - Returns: The name of the type that will be used in Lua
	static var typeName: StaticString { get }
	
	/// A function to act as an initializer for Lua
	static var initializer: LuaInitializer<Self>? { get }
	
	/// A list of static functions available from Lua
	static var functions: [(String, LuaFunction)] { get }
	
	/// A list of methods available from Lua
	static var methods: [(String, LuaMethod<Self>)] { get }
}
