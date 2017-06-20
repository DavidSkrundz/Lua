//
//  LuaVM+Code.swift
//  Lua
//

import CLua

import Foundation

extension LuaVM {
	/// Calls a function in protected mode.  Does not allow it to yield
	///
	/// Removes the `Function` and its arguments from the stack
	///
	/// - Parameter nargs: The number of arguments pushed on the stack
	/// - Parameter nrets: The number of results to be pushed onto the stack. 
	///                    Can be `MultipleReturns` to push all results
	/// - Parameter messageHandlerIndex: The index of handler function that is
	///                                  used to modify (add information to) the
	///                                  error message. Defaults to `0` (none)
	///
	/// - Throws: `LuaError.Runtime`, `LuaError.MessageHandler`, or
	///           `LuaError.GarbageCollector` depending on the error
	internal func protectedCall(nargs: Count, nrets: Count,
	                            messageHandlerIndex: Index = 0) throws {
		let result = lua_pcallk(self.state,
		                        nargs, nrets,
		                        messageHandlerIndex,
		                        0, nil)
		let status = Status(rawValue: result)
		if status == .OK { return }
		let message = self.getString(atIndex: TopIndex)!
		self.pop(1)
		switch status {
			case .RunError:    throw LuaError.Runtime(message)
			case .MemoryError: fatalError("Out of memory")
			case .Error:       throw LuaError.MessageHandler(message)
			case .ErrGCMM:     throw LuaError.GarbageCollector(message)
			default:           fatalError("Unhandled Status: \(status)")
		}
	}
	
	/// Load a `String` as a Lua chunk without running it
	///
	/// - Parameter code: The `String` to be loaded
	///
	/// - Throws: `LuaError.Syntax` or `LuaError.GarbageCollector` depending on
	///           the error
	internal func load(code: String) throws {
		let result = luaL_loadstring(self.state, code)
		let status = Status(rawValue: result)
		if status == .OK { return }
		let message = self.getString(atIndex: TopIndex)!
		self.pop(1)
		switch status {
			case .SyntaxError: throw LuaError.Syntax(message)
			case .MemoryError: fatalError("Out of memory")
			case .ErrGCMM:     throw LuaError.GarbageCollector(message)
			default:           fatalError("Unhandled Status: \(status)")
		}
	}
	
	/// Load a file as a Lua chunk without running it
	///
	/// - Parameter file: The path to the file to load
	///
	/// - Throws: `LuaError.Syntax`, `LuaError.GarbageCollector`, or 
	///           `LuaError.IO` depending on the error
	internal func load(file: URL) throws {
		let result = luaL_loadfilex(self.state, file.path, nil)
		let status = Status(rawValue: result)
		if status == .OK { return }
		let message = self.getString(atIndex: TopIndex)!
		self.pop(1)
		switch status {
			case .SyntaxError: throw LuaError.Syntax(message)
			case .MemoryError: fatalError("Out of memory")
			case .ErrGCMM:     throw LuaError.GarbageCollector(message)
			case .IOError:     throw LuaError.IO(message)
			default:           fatalError("Unhandled Status: \(status)")
		}
	}
	
	/// Load a `CLuaFunction` onto the stack
	///
	/// - Parameter function: The function to load
	/// - Parameter valueCount: The number of values on the stack that should
	///                         be bound to the function
	internal func load(function: @escaping CLuaFunction, valueCount: Count) {
		lua_pushcclosure(self.state, function, valueCount)
	}
	
	/// Store a `LuaFunction` into `self` for use from Lua
	///
	/// The Lua `Function` is put to the top of the stack
	internal func register(function: @escaping LuaFunction) {
		// TODO: Find a way to know when the function gets garbage collected
		// TODO: Free the function from `self.functions`
		
		
		// Push a weak pointer to self
		self.push(Unmanaged.passUnretained(self).toOpaque())
		// Push the index of the function
		self.push(self.functions.count)
		
		self.load(function: wrapperFunction, valueCount: 2)
		
		self.functions.append(function)
	}
}

/// Turn a `LuaFunction` into a `CLuaFunction`
private func wrapperFunction(_ state: OpaquePointer!) -> Count {
	let lua = Lua(raw: LuaVM(state: state))
	
	let selfLuaIndex = lua.raw.upValueIndex(index: 1)
	let selfLuaPointer = lua.raw.getUserData(atIndex: selfLuaIndex)
	let selfLuaVM = Unmanaged<LuaVM>
		.fromOpaque(selfLuaPointer!)
		.takeUnretainedValue()
	
	let closureIndexIndex = lua.raw.upValueIndex(index: 2)
	let closureIndex = lua.raw.getInt(atIndex: closureIndexIndex)!
	let closure = selfLuaVM.functions[closureIndex]
	
	let values = closure(lua)
	values.forEach { lua.push(value: $0) }
	return Count(values.count)
}
