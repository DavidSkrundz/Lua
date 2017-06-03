//
//  Type.swift
//  Lua
//

import CLua

public enum Type: RawRepresentable {
	case Number
	case String
	
	public typealias RawValue = Int32
	
	public init(rawValue: RawValue) {
		switch rawValue {
			case LUA_TNUMBER:        self = .Number
			case LUA_TSTRING:        self = .String
			default:                 fatalError("Unhandled value: \(rawValue)")
		}
	}
	
	public var rawValue: RawValue {
		switch self {
			case .Number:        return LUA_TNUMBER
			case .String:        return LUA_TSTRING
		}
	}
}
