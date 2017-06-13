//
//  Lua+Pop.swift
//  Lua
//

extension Lua {
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
}
