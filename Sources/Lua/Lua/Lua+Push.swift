//
//  Lua+Push.swift
//  Lua
//

extension Lua {
	/// Push a `Value` onto the stack
	internal func push(value: Value) {
		switch value {
			case is Int:    self.raw.push(value as! Int)
			case is Number: self.push(valueOf: (value as! Number).reference)
			default:        fatalError("Unhandled type: \(type(of: value))")
		}
	}
	
	/// Push the `Value` that pointed to by `Reference`
	internal func push(valueOf reference: Reference) {
		self.raw.getFieldRaw(reference.rawValue, atIndex: RegistryIndex)
	}
}
