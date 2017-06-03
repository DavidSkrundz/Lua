//
//  Status.swift
//  Lua
//

import CLua

internal enum Status: RawRepresentable {
	case OK
	case Yield
	case RunError
	case SyntaxError
	case MemoryError
	case ErrGCMM
	case Error
	
	internal typealias RawValue = Int32
	
	internal init(rawValue: RawValue) {
		switch rawValue {
			case LUA_OK:        self = .OK
			case LUA_YIELD:     self = .Yield
			case LUA_ERRRUN:    self = .RunError
			case LUA_ERRSYNTAX: self = .SyntaxError
			case LUA_ERRMEM:    self = .MemoryError
			case LUA_ERRGCMM:   self = .ErrGCMM
			case LUA_ERRERR:    self = .Error
			default:            fatalError("Unhandled value: \(rawValue)")
		}
	}
	
	internal var rawValue: RawValue {
		switch self {
			case .OK:          return LUA_OK
			case .Yield:       return LUA_YIELD
			case .RunError:    return LUA_ERRRUN
			case .SyntaxError: return LUA_ERRSYNTAX
			case .MemoryError: return LUA_ERRMEM
			case .ErrGCMM:     return LUA_ERRGCMM
			case .Error:       return LUA_ERRERR
		}
	}
}
