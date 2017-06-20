//
//  LuaVM+Check.swift
//  Lua
//

import CLua

extension LuaVM {
	/// Check whether the `Value` at `Index` is of `Type`
	internal func checkType(atIndex index: Index, type: Type) {
		luaL_checktype(self.state, index, type.rawValue)
	}
	
	/// Check whether the `Value` at `Index` is a `UserData` of `Type`
	///
	/// Raises a Lua error if the types do not match
	internal func checkUserData(atIndex index: Index,
	                          type: UserDataConvertible.Type) -> Value {
		guard let ptr = luaL_testudata(self.state, index,
		                               String(describing: type.typeName)) else {
			let foundType: String
			let t = self.type(atIndex: index)
			switch t {
				case .UserData:
					if self.getMetatable(atIndex: index) {
						let meta = Table(lua: Lua(raw: self))
						foundType = (meta["__name"] as? String) ?? t.description
					} else {
						foundType = t.description
					}
				default:
					foundType = t.description
			}
			self.argumentError(index,
			                   "\(type.typeName) expected, got \(foundType)")
		}
		return ptr.assumingMemoryBound(to: UserDataConvertible.self).pointee
	}
}
