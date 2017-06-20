//
//  CustomType.swift
//  Lua
//

/// Holds a type's metatable and statictable
public final class CustomType<T: LuaConvertible> {
	private let metaTable: Table
	private let staticTable: Table
	
	internal init(lua: Lua, type: T.Type) throws {
		try lua.raw.createMetatable(name: String(describing: T.typeName))
		self.metaTable = lua.pop() as! Table
		self.staticTable = lua.createTable()
		
		lua.globals[String(describing: T.typeName)] = self.staticTable
		
		if let initializer = T.initializer {
			self.staticTable["new"] = lua.createFunction(Lua.wrap(initializer))
		}
		T.functions.forEach { self.staticTable[$0] = lua.createFunction($1) }
		
		self.metaTable["__name"] = String(describing: T.typeName)
		self.metaTable["__index"] = self.metaTable
		T.methods.forEach {
			self.metaTable[$0] = lua.createFunction(Lua.wrap($1))
		}
		
		self.metaTable["__gc"] = lua.createFunction({ (lua) -> [Value] in
			let userdata = lua.pop() as! UserData
			let pointer: UnsafeMutablePointer<T> = userdata.pointer()
			pointer.deinitialize()
			return []
		})
	}
}
