//
//  Lua.swift
//  Lua
//

/// Represents a single thread of a Lua Virtual Machine
///
/// Provides convenience swift functions
public final class Lua {
	public static let version = LuaVM.versionString
	public static let majorVersion = LuaVM.majorVersion
	public static let minorVersion = LuaVM.minorVersion
	public static let patchVersion = LuaVM.patchVersion
	
	/// Holds `LuaFunction`s and `WrappedFunction`s indexed by a `Reference`
	fileprivate var functions = [Int : Any]()
	
	public let raw: LuaVM
	
	/// Create a new Lua Virtual Machine
	public init() {
		self.raw = LuaVM()
	}
	
	/// Create a new Lua Thread
	internal init(raw: LuaVM) {
		self.raw = raw
	}
	
	/// The `Table` containing all of the global variables
	public var globals: Table {
		self.raw.getFieldRaw(RegistryGlobalsIndex, atIndex: RegistryIndex)
		return Table(lua: self)
	}
	
	/// Run a `String` of Lua code as a `Function` that takes no arguments
	///
	/// - Parameter code: The Lua code to run
	///
	/// - Returns: Any `Value`s returned by the Lua code
	public func run(_ code: String) throws -> [Value] {
		let originalStackSize = self.raw.stackSize()
		try self.raw.load(code: code)
		try self.raw.protectedCall(nargs: 0, nrets: MultipleReturns)
		return self.popValues(toSize: originalStackSize)
	}
	
	/// Call a `Function` with the provided arguments
	///
	/// - Parameter function: The `Function` to call
	/// - Parameter arguments: A list of arguments to pass
	///
	/// - Returns: The `[Value]` returned by the function
	public func call(function: Function,
	                 arguments: [Value] = []) throws -> [Value] {
		let originalStackSize = self.raw.stackSize()
		self.push(value: function)
		arguments.forEach { self.push(value: $0) }
		try self.raw.protectedCall(nargs: Count(arguments.count),
		                           nrets: MultipleReturns)
		return self.popValues(toSize: originalStackSize)
	}
	
	/// Pop values off the stack until `self.raw.stackSize()` is equal to `size`
	///
	/// - Precondition: `self.raw.stackSize() >= size`
	///
	/// - Parameter size: The target size of the stack
	///
	/// - Returns: The values that were popped in the reverse order (first value
	///            popped is the last in the list)
	public func popValues(toSize size: Index) -> [Value] {
		precondition(self.raw.stackSize() >= size)
		return (size..<self.raw.stackSize())
			.map { _ in self.pop() }
			.reversed()
	}
	
	/// Pop the top `Value` off the stack
	///
	/// - Returns: The popped `Value`
	public func pop() -> Value {
		let value: Value
		switch self.raw.type(atIndex: TopIndex) {
			case .LightUserData: value = LightUserData(lua: self)
			case .Number:
				self.raw.pushValue(atIndex: TopIndex)
				value = Number(lua: self)
			case .String:        value = self.raw.getString(atIndex: TopIndex)!
			case .Table:
				self.raw.pushValue(atIndex: TopIndex)
				value = Table(lua: self)
			case .Function:
				self.raw.pushValue(atIndex: TopIndex)
				value = Function(lua: self)
		}
		self.raw.pop(1)
		return value
	}
	
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
				self.raw.error("Invalid number of arguments. Got \(lua.raw.stackSize()) expecting \(inputTypes.count)")
			}
			
			var inputs = [Value]()
			for type in inputTypes.reversed() {
				let foundType = lua.raw.type(atIndex: TopIndex)
				if type != foundType {
					self.raw.error("Invalid argument type. Found \(foundType) expecting \(type)")
				}
				inputs.append(self.pop())
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
