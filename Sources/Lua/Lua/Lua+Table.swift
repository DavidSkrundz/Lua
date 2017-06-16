//
//  Lua+Table.swift
//  Lua
//

extension Lua {
	/// Create a new empty `Table`
	///
	/// - Parameter size: An estimate of how many elements the table will have
	///                   as a sequence
	/// - Parameter count: An estimate of how many other elements the table will
	///                    have
	///
	/// - Returns: The new `Table`
	public func createTable(size: Count = 0, count: Count = 0) -> Table {
		self.raw.createTable(size: size, count: count)
		return Table(lua: self)
	}
	
	/// Set `meta` as the metatable of `target`
	///
	/// - Parameter meta: The metatable to set
	/// - Parameter target: The `Table` whose metatable to set
	public func setMetatable(_ meta: Table, for target: Table) {
		self.push(value: target)
		self.push(value: meta)
		// TODO: Make sure this is correct and not `SecondIndex`
		self.raw.setMetatable(atIndex: TopIndex)
		self.raw.pop(1)
	}
}
