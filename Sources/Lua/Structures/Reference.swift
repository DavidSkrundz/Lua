//
//  Reference.swift
//  Lua
//

import CLua

/// Represents a `Lua` reference created by `
internal struct Reference: RawRepresentable, Hashable, Equatable {
	/// The default `Reference` if it does not exist.  Guaranteed to be unique
	internal static let None = Reference(rawValue: LUA_NOREF)
	/// The `Reference` returned for `Nil` objects
	internal static let Nil  = Reference(rawValue: LUA_REFNIL)
	
	internal let rawValue: Index
	
	var hashValue: Int {
		return Int(self.rawValue)
 }
}
