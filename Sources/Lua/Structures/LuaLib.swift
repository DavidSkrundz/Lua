//
//  LuaLib.swift
//  Lua
//

import CLua

public enum LuaLib {
	case All
	
	case Base
	case Package
	case Coroutine
	case Table
	case IO
	case OS
	case String
	case Bit32
	case Math
	case Debug
	
	internal var loadFunction: LuaLoadFunction {
		switch self {
			case .All:       return { luaL_openlibs($0); return 0 }
			case .Base:      return luaopen_base
			case .Package:   return luaopen_package
			case .Coroutine: return luaopen_coroutine
			case .Table:     return luaopen_table
			case .IO:        return luaopen_io
			case .OS:        return luaopen_os
			case .String:    return luaopen_string
			case .Bit32:     return luaopen_bit32
			case .Math:      return luaopen_math
			case .Debug:     return luaopen_debug
		}
	}
}
