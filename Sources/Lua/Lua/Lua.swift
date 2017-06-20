//
//  Lua.swift
//  Lua
//

/// Represents a single thread of a Lua Virtual Machine
///
/// Provides convenience swift functions
public final class Lua {
	/// Provides access to the raw Lua calls
	public let raw: LuaVM
	
	/// Create a new Lua Virtual Machine
	public init() {
		self.raw = LuaVM()
	}
	
	/// Create a new Lua Thread
	internal init(raw: LuaVM) {
		self.raw = raw
	}
	
	/// The `Table` containing all of the global variables
	public var globals: Table {
		self.raw.getFieldRaw(RegistryGlobalsIndex, atIndex: RegistryIndex)
		return Table(lua: self)
	}
}
