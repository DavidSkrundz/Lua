//
//  UserData.swift
//  Lua
//

/// Represent a userdata within Lua
public final class UserData {
	private let lua: Lua
	internal let reference: Reference
	
	/// Create a new `UserData` by popping the top value from the stack
	internal init(lua: Lua) {
		self.lua = lua
		self.reference = self.lua.popWithReference()
	}
	
	deinit {
		self.lua.release(self.reference)
	}
	
	/// Perform equality between two `UserData`s
	///
	/// - Parameter rhs: The `UserData` to compare to
	///
	/// - Returns: `true` if the `UserData`s are the same object
	fileprivate func isEqual(to other: UserData) -> Bool {
		self.lua.push(value: self)
		self.lua.push(value: other)
		defer { self.lua.raw.pop(2) }
		return self.lua.raw.compare(index1: TopIndex, index2: SecondIndex,
		                            comparator: .Equal)
	}
	
	/// - Returns: `self`'s pointer
	public func rawPointer() -> UnsafeMutablePointer<UserDataConvertible> {
		self.lua.push(value: self)
		let pointer = self.lua.raw.getUserData(atIndex: TopIndex)
		self.lua.raw.pop(1)
		return pointer!.assumingMemoryBound(to: UserDataConvertible.self)
	}
	
	/// - Returns: `self`'s pointer cast to a `T`
	public func pointer<T: UserDataConvertible>() -> UnsafeMutablePointer<T> {
		return self
			.rawPointer()
			.withMemoryRebound(to: T.self, capacity: 1, { $0 })
	}
	
	/// Cast `self`'s pointer data to a `T`
	public func toType<T: UserDataConvertible>() -> T {
		return self.pointer().pointee
	}
}

extension UserData: Equatable {}

public func ==(lhs: UserData, rhs: UserData) -> Bool {
	return lhs.isEqual(to: rhs)
}
