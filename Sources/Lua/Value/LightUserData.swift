//
//  LightUserData.swift
//  Lua
//

/// Represent a light userdata within Lua
public final class LightUserData {
	private let lua: Lua
	public let pointer: UnsafeMutableRawPointer
	
	/// Create a new `LightUserData` by popping the top value from the stack
	internal init(lua: Lua) {
		self.lua = lua
		self.pointer = self.lua.raw.getUserData(atIndex: TopIndex)!
	}
	
	/// Perform equality between two `LightUserData`s
	///
	/// - Parameter rhs: The `LightUserData` to compare to
	///
	/// - Returns: `true` if the `LightUserData`s are the same object
	fileprivate func isEqual(to other: LightUserData) -> Bool {
		self.lua.push(value: self)
		self.lua.push(value: other)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: TopIndex, index2: SecondIndex,
		                            comparator: .Equal)
	}
}

extension LightUserData: Equatable {}

public func ==(lhs: LightUserData, rhs: LightUserData) -> Bool {
	return lhs.isEqual(to: rhs)
}
