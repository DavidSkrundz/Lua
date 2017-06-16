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
extension Function: Value {}
extension LightUserData: Value {}

public func equal(_ lhs: Value, _ rhs: Value) -> Bool {
	switch (lhs, rhs) {
		case is (Int, Int):                     return (lhs as! Int) == (rhs as! Int)
		case is (UInt32, UInt32):               return (lhs as! UInt32) == (rhs as! UInt32)
		case is (Double, Double):               return (lhs as! Double) == (rhs as! Double)
		case is (String, String):               return (lhs as! String) == (rhs as! String)
		case is (Number, Number):               return (lhs as! Number) == (rhs as! Number)
		case is (Table, Table):                 return (lhs as! Table) == (rhs as! Table)
		case is (Function, Function):           return (lhs as! Function) == (rhs as! Function)
		case is (LightUserData, LightUserData): return (lhs as! LightUserData) == (rhs as! LightUserData)
		
		case is (Int, Number):                  return (lhs as! Int) == (rhs as! Number).intValue
		case is (UInt32, Number):               return (lhs as! UInt32) == (rhs as! Number).uintValue
		case is (Double, Number):               return (lhs as! Double) == (rhs as! Number).doubleValue
		case is (Number, Int):                  return (lhs as! Number).intValue == (rhs as! Int)
		case is (Number, UInt32):               return (lhs as! Number).uintValue == (rhs as! UInt32)
		case is (Number, Double):               return (lhs as! Number).doubleValue == (rhs as! Double)
		
		default:                                fatalError("Unhandled Value equality combination")
	}
}

public func ==(lhs: [Value], rhs: [Value]) -> Bool {
	if lhs.count != rhs.count { return false }
	return zip(lhs, rhs)
		.map { equal($0, $1) }
		.reduce(true) { $0 && $1 }
}

public func !=(lhs: [Value], rhs: [Value]) -> Bool {
	return !(lhs == rhs)
}
