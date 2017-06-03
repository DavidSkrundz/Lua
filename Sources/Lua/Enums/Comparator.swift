//
//  Comparator.swift
//  Lua
//

import CLua

public enum Comparator {
	case Equal
	case LessThan
	case GreaterThan
	case LessThanEqual
	case GreaterThanEqual
}

internal enum LuaComparator: RawRepresentable {
	case Equal
	case LessThan
	case LessThanEqual
	
	public typealias RawValue = Int32
	
	public init(rawValue: RawValue) {
		switch rawValue {
			case LUA_OPEQ: self = .Equal
			case LUA_OPLT: self = .LessThan
			case LUA_OPLE: self = .LessThanEqual
			default:       fatalError("Unhandled value: \(rawValue)")
		}
	}
	
	public var rawValue: RawValue {
		switch self {
			case .Equal:         return LUA_OPEQ
			case .LessThan:      return LUA_OPLT
			case .LessThanEqual: return LUA_OPLE
		}
	}
}
