//
//  Comparator.swift
//  Lua
//

import CLua

internal enum Comparator: RawRepresentable {
	case Equal
	case LessThan
	case LessThanEqual
	
	internal typealias RawValue = Int32
	
	internal init(rawValue: RawValue) {
		switch rawValue {
			case LUA_OPEQ: self = .Equal
			case LUA_OPLT: self = .LessThan
			case LUA_OPLE: self = .LessThanEqual
			default:       fatalError("Unhandled value: \(rawValue)")
		}
	}
	
	internal var rawValue: RawValue {
		switch self {
			case .Equal:         return LUA_OPEQ
			case .LessThan:      return LUA_OPLT
			case .LessThanEqual: return LUA_OPLE
		}
	}
}
