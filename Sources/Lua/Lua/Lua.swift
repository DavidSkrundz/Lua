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
	
	public let raw: LuaVM
	
	/// Create a new Lua Virtual Machine
	public init() {
		self.raw = LuaVM()
	}
	
	/// Run a `String` of Lua code as a `Function` that takes no arguments
	///
	/// - Parameter code: The Lua code to run
	///
	/// - Returns: Any `Value`s returned by the Lua code
	public func run(_ code: String) throws -> [Value] {
		let originalStackSize = self.raw.stackSize()
		try self.raw.load(code: code)
		try self.raw.protectedCall(nargs: 0, nrets: MultipleReturns)
		return self.popValues(toSize: originalStackSize)
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
			case .Number:
				self.raw.pushValue(atIndex: TopIndex)
				value = Number(lua: self)
			case .String:        value = self.raw.getString(atIndex: TopIndex)!
		}
		self.raw.pop(1)
		return value
	}
}
