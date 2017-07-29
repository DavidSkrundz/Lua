//
//  Table.swift
//  Lua
//

/// Represent a table within Lua
public class Table {
	private let lua: Lua
	internal let reference: Reference
	
	public var hashValue: Int {
		return Int(self.reference.rawValue)
	}
	
	/// Create a new `Table` by popping the top value from the stack
	internal init(lua: Lua) {
		self.lua = lua
		self.reference = self.lua.popWithReference()
	}
	
	deinit {
		self.lua.release(self.reference)
	}
	
	/// Access a field within the `Table`
	///
	/// - Precondition: `key` cannot be `Nil`
	public subscript(key: Value) -> Value {
		get {
			precondition(!(key is Nil))
			self.lua.push(value: self)
			self.lua.push(value: key)
			self.lua.raw.getTable(atIndex: SecondIndex)
			defer { self.lua.raw.pop(1) }
			return self.lua.pop()
		}
		set {
			precondition(!(key is Nil))
			self.lua.push(value: self)
			self.lua.push(value: key)
			self.lua.push(value: newValue)
			self.lua.raw.setTable(atIndex: ThirdIndex)
			self.lua.raw.pop(1)
		}
	}
	
	/// Calls the given closure on each key-value pair in the table
	public func forEach(body: (TableKey, Value) -> Void) {
		self.lua.push(value: self)
		self.lua.raw.pushNil()
		while self.lua.raw.next(atIndex: SecondIndex) {
			let value = self.lua.pop()
			let key = self.lua.get(atIndex: TopIndex)
			body(TableKey(key), value)
		}
	}
	
	/// Uses `self.forEach` to construct a `[TableKey : Value]` and returns it
	public func toDictionary() -> [TableKey : Value] {
		var dict = [TableKey : Value]()
		self.forEach { (key, value) in dict[key] = value }
		return dict
	}
	
	/// Perform equality between two `Table`s
	///
	/// - Parameter rhs: The `Table` to compare to
	///
	/// - Returns: `true` if the `Table`s are the same object
	fileprivate func isEqual(to other: Table) -> Bool {
		self.lua.push(value: self)
		self.lua.push(value: other)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: TopIndex, index2: SecondIndex,
		                            comparator: .Equal)
	}
}

extension Table: Equatable {}

public func ==(lhs: Table, rhs: Table) -> Bool {
	return lhs.isEqual(to: rhs)
}
