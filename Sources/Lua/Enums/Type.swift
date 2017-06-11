//
//  Type.swift
//  Lua
//

import CLua

public enum Type: RawRepresentable {
	case LightUserData
	case Number
	case String
	case Table
	case Function
	
	public typealias RawValue = Int32
	
	public init(rawValue: RawValue) {
		switch rawValue {
			case LUA_TLIGHTUSERDATA: self = .LightUserData
			case LUA_TNUMBER:        self = .Number
			case LUA_TSTRING:        self = .String
			case LUA_TTABLE:         self = .Table
			case LUA_TFUNCTION:      self = .Function
			default:                 fatalError("Unhandled value: \(rawValue)")
		}
	}
	
	public var rawValue: RawValue {
		switch self {
			case .LightUserData: return LUA_TLIGHTUSERDATA
			case .Number:        return LUA_TNUMBER
			case .String:        return LUA_TSTRING
			case .Table:         return LUA_TTABLE
			case .Function:      return LUA_TFUNCTION
		}
	}
}

extension Type: CustomStringConvertible {
	public var description: String {
		switch self {
			case .LightUserData: return "lightuserdata"
			case .Number:        return "number"
			case .String:        return "string"
			case .Table:         return "table"
			case .Function:      return "function"
		}
	}
}
