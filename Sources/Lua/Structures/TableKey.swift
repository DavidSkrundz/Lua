//
//  TableKey.swift
//  Lua
//

public struct TableKey: Hashable {
	public let value: Value
	
	public var hashValue: Int {
		return self.value.hashValue
	}
	
	public init(_ value: Value) {
		self.value = value
	}
}

public func ==(lhs: TableKey, rhs: TableKey) -> Bool {
	return equal(lhs.value, rhs.value)
}
