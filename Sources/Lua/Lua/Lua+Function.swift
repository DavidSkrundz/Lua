//
//  Lua+Function.swift
//  Lua
//

extension Lua {
	/// Create a new `Function` from a `(Lua) -> [Value]` closure
	///
	/// - Parameter closure: The closure that will be run
	///
	/// - Returns: The new `Function`
	public func createFunction(_ closure: @escaping LuaFunction) -> Function {
		self.raw.register(function: closure)
		return Function(lua: self)
	}
	
	/// Create a new `Function` from a `([Value]) -> [Value]` closure
	///
	/// Used when the types of the arguments are fixed and an error should be
	/// raised if the types don't match
	///
	/// - Parameter closure: The closure that will be run
	///
	/// - Returns: The new `Function`
	public func createFunction(_ inputTypes: [Type],
	                           closure: @escaping WrappedFunction) -> Function {
		return self.createFunction(Lua.wrap(inputTypes, closure: closure))
	}
	
	/// Turn a `WrappedFunction` into a `LuaFunction`
	public static func wrap(_ inputTypes: [Type],
	                        closure: @escaping WrappedFunction) -> LuaFunction {
		return { (lua) -> [Value] in
			let inputs = self.extractValues(from: lua, withTypes: inputTypes)
			return closure(inputs)
		}
	}
	
	/// Turn a `LuaMethod` into a `LuaFunction`
	internal static func wrap<T: LuaConvertible>(_ closure: @escaping LuaMethod<T>) -> LuaFunction {
		return { (lua) -> [Value] in
			if lua.raw.stackSize() == 0 {
				lua.raw.argumentError(1, "missing instance argument")
			}
			
			let obj: T = (lua.pop(index: BottomIndex) as! UserData).toType()
			return closure(obj, lua)
		}
	}
	
	/// Turn a `WrappedMethod` into a `LuaMethod`
	public static func wrap<T: LuaConvertible>(_ inputTypes: [Type],
	                        closure: @escaping WrappedMethod<T>) -> LuaMethod<T> {
		return { (obj, lua) -> [Value] in
			let inputs = self.extractValues(from: lua, withTypes: inputTypes)
			return closure(obj, inputs)
		}
	}
	
	/// Turn a `LuaInitializer` into a `LuaFunction`
	internal static func wrap<T: LuaConvertible>(_ closure: @escaping LuaInitializer<T>) -> LuaFunction {
		return { (lua) -> [Value] in
			return [closure(lua)]
		}
	}
	
	/// Turn a `WrappedInitializer` into a `LuaInitializer`
	public static func wrap<T: LuaConvertible>(_ inputTypes: [Type],
	                        closure: @escaping WrappedInitializer<T>) -> LuaInitializer<T> {
		return { (lua) -> T in
			let inputs = self.extractValues(from: lua, withTypes: inputTypes)
			return closure(inputs)
		}
	}
	
	/// Extract `[Value]` from a `Lua` object matching the `[Type]`
	private static func extractValues(from lua: Lua,
	                                  withTypes types: [Type]) -> [Value] {
		if Int(lua.raw.stackSize()) != types.count {
			lua.raw.error("bad argument count: Got \(lua.raw.stackSize()) expecting \(types.count)")
		}
		
		var values = [Value]()
		for index in 1..<Index(types.count + 1) {
			if case Type.Custom(let customType) = types[Int(index-1)] {
				let v = lua.raw.checkUserData(atIndex: index, type: customType)
				values.append(v)
			} else {
				lua.raw.checkType(atIndex: index, type: types[Int(index-1)])
				lua.raw.pushValue(atIndex: index)
				values.append(lua.pop())
			}
		}
		return values
	}
}
