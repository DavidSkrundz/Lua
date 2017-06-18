//
//  Number.swift
//  Lua
//

public protocol Numeric {}
extension Int: Numeric {}
extension UInt32: Numeric {}
extension Double: Numeric {}

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
	
	/// - Returns: The `Int` representation of `self`
	public var intValue: Int {
		self.lua.push(value: self)
		defer { self.lua.raw.pop(1) }
		return self.lua.raw.getInt(atIndex: TopIndex)!
	}
	
	/// - Returns: The `UInt32` representation of `self`
	public var uintValue: UInt32 {
		self.lua.push(value: self)
		defer { self.lua.raw.pop(1) }
		return self.lua.raw.getUInt(atIndex: TopIndex)!
	}
	
	/// - Returns: The `Double` representation of `self`
	public var doubleValue: Double {
		self.lua.push(value: self)
		defer { self.lua.raw.pop(1) }
		return self.lua.raw.getDouble(atIndex: TopIndex)!
	}
	
	/// Perform a comparison with another `Number`
	///
	/// - Parameter other: The `Number` to compare to
	/// - Parameter comparator: The `Comparator` to use
	///
	/// - Returns: `true` if the comparison holds
	fileprivate func compare(to other: Number, comparator: Comparator) -> Bool {
		self.lua.push(value: self)
		self.lua.push(value: other)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: SecondIndex, index2: TopIndex,
		                            comparator: comparator)
	}
	
	/// Perform a comparison with an `Int`, `UInt32`, or `Double`
	///
	/// - Parameter rhs: The `Int`, `UInt32`, or `Double` to compare to
	/// - Parameter comparator: The `Comparator` to use
	///
	/// - Returns: `true` if the comparison holds
	fileprivate func compare<RHS: Numeric>(toRHS rhs: RHS,
	                         comparator: Comparator) -> Bool {
		self.lua.push(value: self)
		self.lua.push(value: rhs as! Value)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: SecondIndex, index2: TopIndex,
		                            comparator: comparator)
	}
	
	/// Perform a comparison with an `Int`, `UInt32`, or `Double`
	///
	/// - Parameter lhs: The `Int`, `UInt32`, or `Double` to compare to
	/// - Parameter comparator: The `Comparator` to use
	///
	/// - Returns: `true` if the comparison holds
	fileprivate func compare<LHS: Numeric>(toLHS lhs: LHS,
	                         comparator: Comparator) -> Bool {
		self.lua.push(value: lhs as! Value)
		self.lua.push(value: self)
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

public func <=(lhs: Number, rhs: Number) -> Bool {
	return lhs.compare(to: rhs, comparator: .LessThanEqual)
}

// Numeric
public func ==<T: Numeric>(lhs: T, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .Equal)
}

public func <<T: Numeric>(lhs: T, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .LessThan)
}

public func <=<T: Numeric>(lhs: T, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .LessThanEqual)
}

public func !=<T: Numeric>(lhs: T, rhs: Number) -> Bool { return !(lhs == rhs) }
public func ><T: Numeric>(lhs: T, rhs: Number) -> Bool { return !(lhs <= rhs) }
public func >=<T: Numeric>(lhs: T, rhs: Number) -> Bool { return !(lhs < rhs) }

public func ==<T: Numeric>(lhs: Number, rhs: T) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .Equal)
}

public func <<T: Numeric>(lhs: Number, rhs: T) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .LessThan)
}

public func <=<T: Numeric>(lhs: Number, rhs: T) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .LessThanEqual)
}

public func !=<T: Numeric>(lhs: Number, rhs: T) -> Bool { return !(lhs == rhs) }
public func ><T: Numeric>(lhs: Number, rhs: T) -> Bool { return !(lhs <= rhs) }
public func >=<T: Numeric>(lhs: Number, rhs: T) -> Bool { return !(lhs < rhs) }
