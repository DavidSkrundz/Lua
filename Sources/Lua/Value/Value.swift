//
//  Value.swift
//  Lua
//

/// Represents a Lua value that can be converted to a Swift value
///
/// Includes:
/// - `Int`
/// - `UInt32`
/// - `Double`
/// - `String`
/// - `Number`
/// - `Table`
public protocol Value {}

extension Int: Value {}
extension UInt32: Value {}
extension Double: Value {}
extension String: Value {}

extension Number: Value {}
extension Table: Value {}

public func ==(lhs: Value, rhs: Value) -> Bool {
	switch (lhs, rhs) {
		case is (Int, Int):       return (lhs as! Int) == (rhs as! Int)
		case is (UInt32, UInt32): return (lhs as! UInt32) == (rhs as! UInt32)
		case is (Double, Double): return (lhs as! Double) == (rhs as! Double)
		case is (String, String): return (lhs as! String) == (rhs as! String)
		case is (Number, Number): return (lhs as! Number) == (rhs as! Number)
		case is (Table, Table):   return (lhs as! Table) == (rhs as! Table)
		
		case is (Int, Number):    return (lhs as! Int) == (rhs as! Number)
		case is (UInt32, Number): return (lhs as! UInt32) == (rhs as! UInt32)
		case is (Double, Number): return (lhs as! Double) == (rhs as! Double)
		case is (Number, Int):    return (lhs as! Number) == (rhs as! Int)
		case is (Number, Double): return (lhs as! Double) == (rhs as! Double)
		case is (Number, UInt32): return (lhs as! UInt32) == (rhs as! UInt32)
		
		default: fatalError("Unhandled Value equality combination")
	}
}

public func != (lhs: Value, rhs: Value) -> Bool {
	return !(lhs == rhs)
}

public func ==(lhs: [Value], rhs: [Value]) -> Bool {
	if lhs.count != rhs.count { return false }
	return zip(lhs, rhs)
		.map { $0 == $1 }
		.reduce(true) { $0 && $1 }
}

public func !=(lhs: [Value], rhs: [Value]) -> Bool {
	return !(lhs == rhs)
}
