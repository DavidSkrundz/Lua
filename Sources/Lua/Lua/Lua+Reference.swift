//
//  Lua+Reference.swift
//  Lua
//

extension Lua {
	/// Pop the top value of the stack and return a `Reference` to it
	///
	/// The item will not be garbage collected until `release` is called
	///
	/// - Returns: The `Reference` to the item
	internal func popWithReference() -> Reference {
		return self.raw.createReference(inTableAt: RegistryIndex)
	}
	
	/// Release a `Reference` to a value and allow it to be garbage collected
	internal func release(_ reference: Reference) {
		self.raw.release(reference, inTableAt: RegistryIndex)
	}
}
