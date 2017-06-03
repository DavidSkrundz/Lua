//
//  LuaVM+Arithmetic.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Perform a comparison between the values at two indices
	///
	/// - Parameter index1: The `Index` of the first value
	/// - Parameter index2: The `Index` of the second value
	/// - Parameter comparator: The comparison method to use
	///
	/// - Returns: `true` if both indices are valid and the comparison operator 
	///            holds true
	internal func compare(index1: Index, index2: Index,
	                      comparator: Comparator) -> Bool {
		return lua_compare(self.state, index1, index2, comparator.rawValue) == 1
	}
}
