//
//  Lua+Type.swift
//  Lua
//

extension Lua {
	/// Create a new type in Lua from a Swift type
	///
	/// - Parameter type: The Swift type to create in Lua
	///
	/// - Throws: `LuaError.TypeCreation` if the type was already registered
	///
	/// - Returns: A `CustomType<T>` that allows for the modification of the
	///            types methods or properties
	public func createType<T: LuaConvertible>(_ type: T.Type) throws {
		// TODO: Move msot of this to inside CustomType<T>
		
		let staticTable = self.createTable()
		try self.raw.createMetatable(name: String(describing: T.typeName))
		let metaType = CustomType<T>(lua: self)
		
		self.globals[String(describing: T.typeName)] = staticTable
		
		staticTable["new"] = self.createFunction(Lua.wrap(T.initializer))
		T.functions.forEach { staticTable[$0] = self.createFunction($1) }
		
		metaType["__index"] = metaType
		T.methods.forEach { metaType[$0] = self.createFunction(Lua.wrap($1)) }
		
		metaType["__gc"] = self.createFunction({ (lua) -> [Value] in
			let userdata = lua.pop() as! UserData
			let pointer: UnsafeMutablePointer<T> = userdata.pointer()
			pointer.deinitialize()
			return []
		})
		
		// TODO: Populate customType with methods and stuff
		// __eq
	}
}
