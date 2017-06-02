//
//  LuaVM+Reference.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Create a `Reference` in the `Table` at `Index` for the value at the top 
	/// of the stack and pops it
	///
	/// If the value at the top of the stack is `Nil`, returns `.Nil`
	///
	/// - Parameter index: The `Index` of the `Table` on the stack in which the
	///                    `Reference` should be created
	///
	/// - Returns: The `Reference` that was created
	internal func createReference(inTableAt index: Index) -> Reference {
		let ref = luaL_ref(self.state, index)
		return Reference(rawValue: ref)
	}
	
	/// Release `Reference` in the `Table` at `Index` for future use.  This also
	/// potentially allows the value that was reference to be garbage collected
	///
	/// This invalidates all `Reference` objects with the same `rawValue`
	///
	/// - Parameter reference: The `Reference` to be released
	/// - Parameter index: The `Index` on the stack of the `Table` containing
	///                    the `Reference`
	internal func release(_ reference: Reference, inTableAt index: Index) {
		luaL_unref(self.state, index, reference.rawValue)
	}
}
