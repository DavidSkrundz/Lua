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
	
	/// Holds `LuaFunction`s and `WrappedFunction`s indexed by a `Reference`
	internal var functions = [Int : Any]()
	
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
	
	/// Pop values off the stack until `self.raw.stackSize()` is equal to `size`
	///
	/// - Precondition: `self.raw.stackSize() >= size`
	///
	/// - Parameter size: The target size of the stack
	///
	/// - Returns: The values that were popped in the reverse order (first value
	///            popped is the last in the list)
	public func popValues(toSize size: Index) -> [Value] {
		precondition(self.raw.stackSize() >= size)
		return (size..<self.raw.stackSize())
			.map { _ in self.pop() }
			.reversed()
	}
	
	/// Pop the top `Value` off the stack
	///
	/// - Returns: The popped `Value`
	public func pop() -> Value {
		let value: Value
		switch self.raw.type(atIndex: TopIndex) {
			case .LightUserData: value = LightUserData(lua: self)
			case .Number:
				self.raw.pushValue(atIndex: TopIndex)
				value = Number(lua: self)
			case .String:        value = self.raw.getString(atIndex: TopIndex)!
			case .Table:
				self.raw.pushValue(atIndex: TopIndex)
				value = Table(lua: self)
			case .Function:
				self.raw.pushValue(atIndex: TopIndex)
				value = Function(lua: self)
		}
		self.raw.pop(1)
		return value
	}
	
	/// Create a new empty `Table`
	///
	/// - Parameter size: An estimate of how many elements the table will have
	///                   as a sequence
	/// - Parameter count: An estimate of how many other elements the table will
	///                    have
	///
	/// - Returns: The new `Table`
	public func createTable(size: Count = 0, count: Count = 0) -> Table {
		self.raw.createTable(size: size, count: count)
		return Table(lua: self)
	}
}
