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
		// TODO: Find a way to know when the function gets garbage collected
		// TODO: Free the function from `self.functions`
		self.raw.push(1) // Any Value
		let reference = self.popWithReference()
		let index = Int(reference.rawValue)
		self.release(reference)
		
		// Push self
		let selfPointer = Unmanaged.passUnretained(self).toOpaque()
		self.raw.push(selfPointer)
		// Push Reference index
		self.push(value: index)
		
		self.raw.load(function: wrapperFunction, valueCount: 2)
		
		let function = Function(lua: self)
		assert(Int(function.reference.rawValue) == index)
		self.functions[index] = closure
		return function
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
		return self.createFunction { (lua) -> [Value] in
			if Int(lua.raw.stackSize()) != inputTypes.count {
				lua.raw.error("Invalid number of arguments. Got \(lua.raw.stackSize()) expecting \(inputTypes.count)")
			}
			
			var inputs = [Value]()
			for type in inputTypes.reversed() {
				let foundType = lua.raw.type(atIndex: TopIndex)
				if type != foundType {
					lua.raw.error("Invalid argument type. Found \(foundType) expecting \(type)")
				}
				inputs.append(lua.pop())
			}
			return closure(inputs.reversed())
		}
	}
}

/// Wraps a `LuaFunction` as a `CLuaFunction`
private func wrapperFunction(_ state: OpaquePointer!) -> Count {
	let lua = Lua(raw: LuaVM(state: state))
	
	let selfLuaIndex = lua.raw.upValueIndex(index: 1)
	let selfLuaPointer = lua.raw.getUserData(atIndex: selfLuaIndex)
	let selfLua = Unmanaged<Lua>
		.fromOpaque(selfLuaPointer!)
		.takeUnretainedValue()
	
	let closureIndexIndex = lua.raw.upValueIndex(index: 2)
	let closureIndex = lua.raw.getInt(atIndex: closureIndexIndex)!
	let closure = selfLua.functions[closureIndex] as! LuaFunction
	
	let values = closure(lua)
	values.forEach { lua.push(value: $0) }
	return Count(values.count)
}
