//
//  Lua+Arithmetic.swift
//  Lua
//

extension Lua {
	/// Perform a comparison between the values at two indices
	///
	/// - Parameter index1: The `Index` of the first value
	/// - Parameter index2: The `Index` of the second value
	/// - Parameter comparator: The comparison method to use
	///
	/// - Returns: `true` if both indices are valid and the comparison operator
	///            holds true
	public func compare(index1: Index, index2: Index,
	                      comparator: Comparator) -> Bool {
		switch comparator {
			case .Equal:
				return self.raw.compare(index1: index1, index2: index2,
				                        comparator: .Equal)
			case .LessThan:
				return self.raw.compare(index1: index1, index2: index2,
				                        comparator: .LessThan)
			case .GreaterThan:
				return !self.raw.compare(index1: index1, index2: index2,
				                         comparator: .LessThanEqual)
			case .LessThanEqual:
				return self.raw.compare(index1: index1, index2: index2,
				                        comparator: .LessThanEqual)
			case .GreaterThanEqual:
				return !self.raw.compare(index1: index1, index2: index2,
				                         comparator: .LessThan)
		}
	}
}
