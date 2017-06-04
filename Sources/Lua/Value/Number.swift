//
//  Number.swift
//  Lua
//

private protocol NumberComparable: Value {}
extension Int: NumberComparable {}
extension UInt32: NumberComparable {}
extension Double: NumberComparable {}

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
		self.lua.push(valueOf: self.reference)
		defer { self.lua.raw.pop(1) }
		return self.lua.raw.getInt(atIndex: TopIndex)!
	}
	
	/// - Returns: The `UInt32` representation of `self`
	public var uintValue: UInt32 {
		self.lua.push(valueOf: self.reference)
		defer { self.lua.raw.pop(1) }
		return self.lua.raw.getUInt(atIndex: TopIndex)!
	}
	
	/// - Returns: The `Double` representation of `self`
	public var doubleValue: Double {
		self.lua.push(valueOf: self.reference)
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
		self.lua.push(valueOf: self.reference)
		self.lua.push(valueOf: other.reference)
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
	fileprivate func compare<RHS: NumberComparable>(toRHS rhs: RHS,
	                         comparator: Comparator) -> Bool {
		self.lua.push(valueOf: self.reference)
		self.lua.push(value: rhs)
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
	fileprivate func compare<LHS: NumberComparable>(toLHS lhs: LHS,
	                         comparator: Comparator) -> Bool {
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

// Int
public func ==(lhs: Int, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .Equal)
}

public func <(lhs: Int, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .LessThan)
}

public func !=(lhs: Int, rhs: Number) -> Bool { return !(lhs == rhs) }
public func <=(lhs: Int, rhs: Number) -> Bool { return lhs < rhs || lhs == rhs }
public func >(lhs: Int, rhs: Number) -> Bool { return !(lhs <= rhs) }
public func >=(lhs: Int, rhs: Number) -> Bool { return !(lhs < rhs) }

public func ==(lhs: Number, rhs: Int) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .Equal)
}

public func <(lhs: Number, rhs: Int) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .LessThan)
}

public func !=(lhs: Number, rhs: Int) -> Bool { return !(lhs == rhs) }
public func <=(lhs: Number, rhs: Int) -> Bool { return lhs < rhs || lhs == rhs }
public func >(lhs: Number, rhs: Int) -> Bool { return !(lhs <= rhs) }
public func >=(lhs: Number, rhs: Int) -> Bool { return !(lhs < rhs) }

// UInt32
public func ==(lhs: UInt32, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .Equal)
}

public func <(lhs: UInt32, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .LessThan)
}

public func !=(lhs: UInt32, rhs: Number) -> Bool { return !(lhs == rhs) }
public func <=(lhs: UInt32, rhs: Number) -> Bool { return lhs < rhs || lhs == rhs }
public func >(lhs: UInt32, rhs: Number) -> Bool { return !(lhs <= rhs) }
public func >=(lhs: UInt32, rhs: Number) -> Bool { return !(lhs < rhs) }

public func ==(lhs: Number, rhs: UInt32) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .Equal)
}

public func <(lhs: Number, rhs: UInt32) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .LessThan)
}

public func !=(lhs: Number, rhs: UInt32) -> Bool { return !(lhs == rhs) }
public func <=(lhs: Number, rhs: UInt32) -> Bool { return lhs < rhs || lhs == rhs }
public func >(lhs: Number, rhs: UInt32) -> Bool { return !(lhs <= rhs) }
public func >=(lhs: Number, rhs: UInt32) -> Bool { return !(lhs < rhs) }

// Double
public func ==(lhs: Double, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .Equal)
}

public func <(lhs: Double, rhs: Number) -> Bool {
	return rhs.compare(toLHS: lhs, comparator: .LessThan)
}

public func !=(lhs: Double, rhs: Number) -> Bool { return !(lhs == rhs) }
public func <=(lhs: Double, rhs: Number) -> Bool { return lhs < rhs || lhs == rhs }
public func >(lhs: Double, rhs: Number) -> Bool { return !(lhs <= rhs) }
public func >=(lhs: Double, rhs: Number) -> Bool { return !(lhs < rhs) }

public func ==(lhs: Number, rhs: Double) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .Equal)
}

public func <(lhs: Number, rhs: Double) -> Bool {
	return lhs.compare(toRHS: rhs, comparator: .LessThan)
}

public func !=(lhs: Number, rhs: Double) -> Bool { return !(lhs == rhs) }
public func <=(lhs: Number, rhs: Double) -> Bool { return lhs < rhs || lhs == rhs }
public func >(lhs: Number, rhs: Double) -> Bool { return !(lhs <= rhs) }
public func >=(lhs: Number, rhs: Double) -> Bool { return !(lhs < rhs) }
