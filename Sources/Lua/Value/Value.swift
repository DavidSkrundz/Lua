//
//  Value.swift
//  Lua
//

/// Represents a Lua value that can be converted to a Swift value
///
/// Includes:
/// - `Int`
/// - `String`
/// - `Number`
public protocol Value {}

extension Int: Value {}
extension String: Value {}

extension Number: Value {}

public func ==(lhs: Value, rhs: Value) -> Bool {
	switch (lhs, rhs) {
		case is (Int, Int):       return (lhs as! Int) == (rhs as! Int)
		case is (String, String): return (lhs as! String) == (rhs as! String)
		case is (Number, Number): return (lhs as! Number) == (rhs as! Number)
		
		case is (Int, Number): return (lhs as! Int) == (rhs as! Number)
		case is (Number, Int): return (lhs as! Number) == (rhs as! Int)
		
		default: return false
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
