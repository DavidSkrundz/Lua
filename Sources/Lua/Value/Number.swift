//
//  Number.swift
//  Lua
//

/// Represents a Lua numeric value since Lua does not make a distinction between
/// `Int` and `Double`
public final class Number {
	private let lua: Lua
	internal let reference: Reference
	
	/// Create a new `Number` by popping the top value from the stack
	internal init(lua: Lua) {
		self.lua = lua
		self.reference = self.lua.popWithReference()
	}
	
	deinit {
		self.lua.release(self.reference)
	}
	
	/// Perform a comparison with another `Number`
	///
	/// - Parameter other: The `Number` to compare to
	/// - Parameter comparator: The `Comparator` to use
	///
	/// - Returns: `true` if the comparison holds
	fileprivate func compare(to other: Number, comparator: Comparator) -> Bool {
		self.lua.push(valueOf: self.reference)
		self.lua.push(valueOf: other.reference)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: SecondIndex, index2: TopIndex,
		                            comparator: comparator)
	}
	
	/// Perform a comparison with an `Int`
	///
	/// - Parameter rhs: The `Int` to compare to
	/// - Parameter comparator: The `Comparator` to use
	///
	/// - Returns: `true` if the comparison holds
	fileprivate func compare(toRHS rhs: Int, comparator: Comparator) -> Bool {
		self.lua.push(valueOf: self.reference)
		self.lua.push(value: rhs)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: SecondIndex, index2: TopIndex,
		                            comparator: comparator)
	}
	
	/// Perform a comparison with an `Int`
	///
	/// - Parameter lhs: The `Int` to compare to
	/// - Parameter comparator: The `Comparator` to use
	///
	/// - Returns: `true` if the comparison holds
	fileprivate func compare(toLHS lhs: Int, comparator: Comparator) -> Bool {
		self.lua.push(value: lhs)
		self.lua.push(valueOf: self.reference)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: SecondIndex, index2: TopIndex,
		                            comparator: comparator)
	}
}

extension Number: Equatable, Comparable {}

public func ==(lhs: Number, rhs: Number) -> Bool {
	return lhs.compare(to: rhs, comparator: .Equal)
}

public func <(lhs: Number, rhs: Number) -> Bool {
	return lhs.compare(to: rhs, comparator: .LessThan)
}

public func ==(lhs: Int, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .Equal)
}

public func <(lhs: Int, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .LessThan)
}

public func ==(lhs: Number, rhs: Int) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .Equal)
}

public func <(lhs: Number, rhs: Int) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .LessThan)
}
