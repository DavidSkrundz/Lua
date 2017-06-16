//
//  Lua.swift
//  Lua
//

/// Represents a single thread of a Lua Virtual Machine
///
/// Provides convenience swift functions
public final class Lua {
	public static let version = LuaVM.versionString
	public static let majorVersion = LuaVM.majorVersion
	public static let minorVersion = LuaVM.minorVersion
	public static let patchVersion = LuaVM.patchVersion
	
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
	
	/// The `Table` that acts as a registry for the Lua Virtual Machine
	public var registry: Table {
		self.raw.pushValue(atIndex: RegistryIndex)
		return Table(lua: self)
	}
	
	/// The `Table` containing all of the global variables
	public var globals: Table {
		self.raw.getFieldRaw(RegistryGlobalsIndex, atIndex: RegistryIndex)
		return Table(lua: self)
	}
}
