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
}
