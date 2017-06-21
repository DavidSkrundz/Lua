//
//  Typealias.swift
//  Lua
//

/// Represents an index (e.g. A stack index)
public typealias Index = Int32

/// Represents a count (e.g. The number of arguments)
public typealias Count = Int32

/// The signature of functions that Lua uses to load standard libraries
internal typealias LuaLoadFunction = (OpaquePointer!) -> Int32

/// The signature of C functions that can be called by Lua
///
/// The `OpaquePointer?` should be used to create a `LuaVM` and is the state
/// that should be used
///
/// The return value is how many values the function pushed onto the stack to
/// return
///
/// The arguments passed to the function are the values pushed onto the stack
internal typealias CLuaFunction = @convention(c) (OpaquePointer?) -> Count

/// The signature of a Swift function that can be called by Lua.  Provides
/// access to the `Lua` object of the call's context
///
/// - Returns: A list of values to return
public typealias LuaFunction = (Lua) -> [Value]

/// The signature of a Swift function that is wrapped to remove the `Lua` object
/// and provides the arguments instead
///
/// - Returns: A list of values to return
public typealias WrappedFunction = ([Value]) -> [Value]

/// The signature of a Swift method that can be called as a method for a
/// custom type from within Lua. Provides access to the `Lua` object of the
/// call's context and the object being called
///
/// - Returns: A list of values to return
public typealias LuaMethod<T> = (T, Lua) -> [Value]

/// The signature of a Swift method that is wrapped to remove the `Lua` object
/// and provides the arguments instead
///
/// - Returns: A list of values to return
public typealias WrappedMethod<T> = (T, [Value]) -> [Value]

/// The signature of a Swift function that is used to initialize a new object
/// of a `CustomType`
public typealias LuaInitializer<T> = (Lua) -> T

/// The signature of a Swift function that is used to initialize a new object
/// of a `CustomType`
public typealias WrappedInitializer<T> = ([Value]) -> T
