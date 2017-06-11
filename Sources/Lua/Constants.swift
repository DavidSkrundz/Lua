//
//  Constants.swift
//  Lua
//

import CLua

/// The `Index` of the top of the stack
public let TopIndex: Index = -1

/// The second `Index` from the top of the stack
public let SecondIndex: Index = -2

/// The third `Index` from the top of the stack
public let ThirdIndex: Index = -3

/// Option for multiple returns in `lua_pcall` and `lua_call`
public let MultipleReturns: Count = LUA_MULTRET

/// The pseudo-index where the registry is found
///
/// found in luaconf.h
internal let RegistryIndex: Index = -LUAI_MAXSTACK - 1000

/// The index in the registry where the global values are stored
public let RegistryGlobalsIndex = LUA_RIDX_GLOBALS

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
