//
//  Number.swift
//  Lua
//

/// Represents a Lua numeric value since Lua does not make a distinction between
/// `Int` and `Double`
public final class Number {
	public let intValue: Int
	public let uintValue: UInt32
	public let doubleValue: Double
	
	public let isInt: Bool
	
	/// Create a new `Number` by popping the top value from the stack
	internal init(lua: Lua) {
		self.intValue = lua.raw.getInt(atIndex: TopIndex)!
		self.uintValue = lua.raw.getUInt(atIndex: TopIndex)!
		self.doubleValue = lua.raw.getDouble(atIndex: TopIndex)!
		lua.raw.pop(1)
		
		self.isInt = Double(self.intValue) == self.doubleValue
	}
}

extension Number: Equatable, Comparable {}

public func ==(lhs: Number, rhs: Number) -> Bool {
	return lhs.doubleValue == rhs.doubleValue
}

public func <(lhs: Number, rhs: Number) -> Bool {
	return lhs.doubleValue < rhs.doubleValue
}

// Int

public func ==(lhs: Number, rhs: Int) -> Bool { return lhs.intValue == rhs }
public func !=(lhs: Number, rhs: Int) -> Bool { return lhs.intValue != rhs }
public func < (lhs: Number, rhs: Int) -> Bool { return lhs.intValue <  rhs }
public func > (lhs: Number, rhs: Int) -> Bool { return lhs.intValue >  rhs }
public func <=(lhs: Number, rhs: Int) -> Bool { return lhs.intValue <= rhs }
public func >=(lhs: Number, rhs: Int) -> Bool { return lhs.intValue >= rhs }

public func ==(lhs: Int, rhs: Number) -> Bool { return lhs == rhs.intValue }
public func !=(lhs: Int, rhs: Number) -> Bool { return lhs != rhs.intValue }
public func < (lhs: Int, rhs: Number) -> Bool { return lhs <  rhs.intValue }
public func > (lhs: Int, rhs: Number) -> Bool { return lhs >  rhs.intValue }
public func <=(lhs: Int, rhs: Number) -> Bool { return lhs <= rhs.intValue }
public func >=(lhs: Int, rhs: Number) -> Bool { return lhs >= rhs.intValue }

// UInt32

public func ==(lhs: Number, rhs: UInt32) -> Bool { return lhs.uintValue == rhs }
public func !=(lhs: Number, rhs: UInt32) -> Bool { return lhs.uintValue != rhs }
public func < (lhs: Number, rhs: UInt32) -> Bool { return lhs.uintValue <  rhs }
public func > (lhs: Number, rhs: UInt32) -> Bool { return lhs.uintValue >  rhs }
public func <=(lhs: Number, rhs: UInt32) -> Bool { return lhs.uintValue <= rhs }
public func >=(lhs: Number, rhs: UInt32) -> Bool { return lhs.uintValue >= rhs }

public func ==(lhs: UInt32, rhs: Number) -> Bool { return lhs == rhs.uintValue }
public func !=(lhs: UInt32, rhs: Number) -> Bool { return lhs != rhs.uintValue }
public func < (lhs: UInt32, rhs: Number) -> Bool { return lhs <  rhs.uintValue }
public func > (lhs: UInt32, rhs: Number) -> Bool { return lhs >  rhs.uintValue }
public func <=(lhs: UInt32, rhs: Number) -> Bool { return lhs <= rhs.uintValue }
public func >=(lhs: UInt32, rhs: Number) -> Bool { return lhs >= rhs.uintValue }

// Double

public func ==(lhs: Number, rhs: Double) -> Bool { return lhs.doubleValue == rhs }
public func !=(lhs: Number, rhs: Double) -> Bool { return lhs.doubleValue != rhs }
public func < (lhs: Number, rhs: Double) -> Bool { return lhs.doubleValue <  rhs }
public func > (lhs: Number, rhs: Double) -> Bool { return lhs.doubleValue >  rhs }
public func <=(lhs: Number, rhs: Double) -> Bool { return lhs.doubleValue <= rhs }
public func >=(lhs: Number, rhs: Double) -> Bool { return lhs.doubleValue >= rhs }

public func ==(lhs: Double, rhs: Number) -> Bool { return lhs == rhs.doubleValue }
public func !=(lhs: Double, rhs: Number) -> Bool { return lhs != rhs.doubleValue }
public func < (lhs: Double, rhs: Number) -> Bool { return lhs <  rhs.doubleValue }
public func > (lhs: Double, rhs: Number) -> Bool { return lhs >  rhs.doubleValue }
public func <=(lhs: Double, rhs: Number) -> Bool { return lhs <= rhs.doubleValue }
public func >=(lhs: Double, rhs: Number) -> Bool { return lhs >= rhs.doubleValue }
