//
//  Type.swift
//  Lua
//

import CLua

public enum Type: RawRepresentable {
	case String
	
	public typealias RawValue = Int32
	
	public init?(rawValue: RawValue) {
		switch rawValue {
			case LUA_TSTRING:        self = .String
			default:                 return nil
		}
	}
	
	public var rawValue: RawValue {
		switch self {
			case .String:        return LUA_TSTRING
		}
	}
}
