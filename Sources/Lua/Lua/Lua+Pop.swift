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
	
	/// Pop the `Value` at `Index` (`TopIndex` by default)
	///
	/// - Returns: The popped `Value`
	public func pop(index: Index = TopIndex) -> Value {
		let value: Value
		switch self.raw.type(atIndex: index) {
			case .LightUserData: value = LightUserData(lua: self)
			case .Number:
				self.raw.pushValue(atIndex: index)
				value = Number(lua: self)
			case .String:        value = self.raw.getString(atIndex: index)!
			case .Table:
				self.raw.pushValue(atIndex: index)
				value = Table(lua: self)
			case .Function:
				self.raw.pushValue(atIndex: index)
				value = Function(lua: self)
			case .UserData:
				self.raw.pushValue(atIndex: index)
				value = UserData(lua: self)
			case .Custom(_):     fatalError("Should never get called")
		}
		self.raw.remove(atIndex: index)
		return value
	}
}
