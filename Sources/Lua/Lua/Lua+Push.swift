//
//  Lua+Push.swift
//  Lua
//

extension Lua {
	/// Push a `Value` onto the stack
	public func push(value: Value) {
		switch value {
			case is Int:            self.raw.push(value as! Int)
			case is UInt32:         self.raw.push(value as! UInt32)
			case is Double:         self.raw.push(value as! Double)
			case is String:         self.raw.push(value as! String)
			case is Number:         self.raw.push((value as! Number).doubleValue)
			case is Table:          self.push(valueOf: (value as! Table).reference)
			case is UserData:       self.push(valueOf: (value as! UserData).reference)
			case is Function:       self.push(valueOf: (value as! Function).reference)
			case is UnsafeMutableRawPointer: self.raw.push((value as! UnsafeMutableRawPointer))
			case is LuaConvertible: self.push(data: (value as! UserDataConvertible))
			default:                fatalError("Unhandled type: \(type(of: value))")
		}
	}
	
	/// Push the `Value` that pointed to by `Reference`
	private func push(valueOf reference: Reference) {
		self.raw.getFieldRaw(reference.rawValue, atIndex: RegistryIndex)
	}
	
	/// Push an instance of a `LuaConvertible` as a `UserData`
	private func push(data: UserDataConvertible) {
		let type = type(of: data)
		let ptr = self.raw.createUserData(size: MemoryLayout<UserDataConvertible>.size)
		ptr.initializeMemory(as: UserDataConvertible.self, to: data)
		let typeName = String(describing: type.typeName)
		self.raw.setMetatable(name: typeName)
	}
}
