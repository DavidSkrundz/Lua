//
//  LuaVM+Debug.swift
//  Lua
//

import CLua

extension LuaVM {
	/// - Returns: The pseudo-index that represents the `Index`-th upvalue of
	///            the running function
	internal func upValueIndex(index: Index) -> Index {
		return RegistryIndex - index
	}
}
