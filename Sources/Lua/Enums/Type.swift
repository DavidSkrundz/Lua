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
	
	public typealias RawValue = Int32
	
	public init(rawValue: RawValue) {
		switch rawValue {
			case LUA_TLIGHTUSERDATA: self = .LightUserData
			case LUA_TNUMBER:        self = .Number
			case LUA_TSTRING:        self = .String
			case LUA_TTABLE:         self = .Table
			default:                 fatalError("Unhandled value: \(rawValue)")
		}
	}
	
	public var rawValue: RawValue {
		switch self {
			case .LightUserData: return LUA_TLIGHTUSERDATA
			case .Number:        return LUA_TNUMBER
			case .String:        return LUA_TSTRING
			case .Table:         return LUA_TTABLE
		}
	}
}
