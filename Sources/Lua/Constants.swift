//
//  Constants.swift
//  Lua
//

import CLua

/// The `Index` of the top of the stack
public let TopIndex: Index = -1

/// Option for multiple returns in `lua_pcall` and `lua_call`
public let MultipleReturns: Count = LUA_MULTRET
