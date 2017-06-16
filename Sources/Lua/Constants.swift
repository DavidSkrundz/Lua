//
//  Constants.swift
//  Lua
//

import CLua

/// The `Index` of the bottom of the stack
public let BottomIndex: Index = 1

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
