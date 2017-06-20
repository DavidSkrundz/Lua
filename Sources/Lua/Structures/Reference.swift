//
//  Reference.swift
//  Lua
//

import CLua

/// Represents a `Lua` reference created by `
internal struct Reference: RawRepresentable, Equatable {
	/// The default `Reference` if it does not exist.  Guaranteed to be unique
	private static let None = Reference(rawValue: LUA_NOREF)
	/// The `Reference` returned for `Nil` objects
	private static let Nil  = Reference(rawValue: LUA_REFNIL)
	
	internal let rawValue: Index
}
