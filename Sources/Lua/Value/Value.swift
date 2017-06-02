//
//  Value.swift
//  Lua
//

/// Represents a Lua value that can be converted to a Swift value
///
/// Includes:
/// - `String`
public protocol Value {}

extension String: Value {}

public func ==(lhs: Value, rhs: Value) -> Bool {
	switch (lhs, rhs) {
		case is (String, String): return (lhs as! String) == (rhs as! String)
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
