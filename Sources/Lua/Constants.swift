//
//  Constants.swift
//  Lua
//

import CLua

/// The `Index` of the bottom of the stack
internal let BottomIndex: Index = 1

/// The `Index` of the top of the stack
internal let TopIndex: Index = -1

/// The second `Index` from the top of the stack
internal let SecondIndex: Index = -2

/// The third `Index` from the top of the stack
internal let ThirdIndex: Index = -3

/// Option for multiple returns in `lua_pcall` and `lua_call`
internal let MultipleReturns: Count = LUA_MULTRET

/// The pseudo-index where the registry is found
///
/// found in luaconf.h
internal let RegistryIndex: Index = -LUAI_MAXSTACK - 1000

/// The index in the registry where the main thread is stored
//private let RegistryMainThreadIndex = LUA_RIDX_MAINTHREAD

/// The index in the registry where the global values are stored
internal let RegistryGlobalsIndex = LUA_RIDX_GLOBALS
