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
				lua.raw.error("Missing instance argument")
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
			lua.raw.error("Invalid number of arguments. Got \(lua.raw.stackSize()) expecting \(types.count)")
		}
		
		var values = [Value]()
		for type in types {
			let foundType = lua.raw.type(atIndex: BottomIndex)
			if type == foundType {
				values.append(lua.pop(index: BottomIndex))
				continue
			}
			if case Type.Custom(let customType) = type, foundType == .UserData {
				// TODO: Check type
				let t = (lua.pop(index: BottomIndex) as! UserData).rawPointer()
				values.append(t.pointee as! Value)
				continue
			}
			lua.raw.error("Invalid argument type. Found \(foundType) expecting \(type)")
		}
		return values
	}
}
