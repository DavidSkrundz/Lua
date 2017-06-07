//
//  Lua+Push.swift
//  Lua
//

extension Lua {
	/// Push a `Value` onto the stack
	internal func push(value: Value) {
		switch value {
			case is Int:           self.raw.push(value as! Int)
			case is UInt32:        self.raw.push(value as! UInt32)
			case is Double:        self.raw.push(value as! Double)
			case is String:        self.raw.push(value as! String)
			case is Number:        self.push(valueOf: (value as! Number).reference)
			case is Table:         self.push(valueOf: (value as! Table).reference)
			case is LightUserData: self.raw.push((value as! LightUserData).pointer)
			default:               fatalError("Unhandled type: \(type(of: value))")
		}
	}
	
	/// Push the `Value` that pointed to by `Reference`
	private func push(valueOf reference: Reference) {
		self.raw.getFieldRaw(reference.rawValue, atIndex: RegistryIndex)
	}
}
