//
//  LuaVM+Code.swift
//  Lua
//

import CLua

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
	/// - Throws: `RuntimeError.Runtime`, `RuntimeError.MemoryAllocation`,
	///           `RuntimeError.MessageHandler`, or 
	///           `RuntimeError.GarbageCollector` depending on the error
	public func protectedCall(nargs: Count, nrets: Count,
	                          messageHandlerIndex: Index = 0) throws {
		let result = lua_pcallk(self.state, nargs, nrets, messageHandlerIndex,
		                        0, nil)
		let status = Status(rawValue: result)
		if status == .OK { return }
		let message = self.getString(atIndex: TopIndex)!
		self.pop(1)
		switch status {
			case .RunError:    throw LuaError.Runtime(message)
			case .MemoryError: throw LuaError.MemoryAllocation(message)
			case .Error:       throw LuaError.MessageHandler(message)
			case .ErrGCMM:     throw LuaError.GarbageCollector(message)
			default:           fatalError("Unhandled Status: \(status)")
		}
	}
	
	/// Load a `String` as a Lua chunk without running it
	///
	/// - Parameter code: The `String` to be loaded
	///
	/// - Throws: `CompilationError.Syntax`, `RuntimeError.MemoryAllocation`, or
	///           `RuntimeError.GarbageCollector` depending on the error
	public func load(code: String) throws {
		let result = luaL_loadstring(self.state, code)
		let status = Status(rawValue: result)
		if status == .OK { return }
		let message = self.getString(atIndex: TopIndex)!
		self.pop(1)
		switch status {
			case .SyntaxError: throw LuaError.Syntax(message)
			case .MemoryError: throw LuaError.MemoryAllocation(message)
			case .ErrGCMM:     throw LuaError.GarbageCollector(message)
			default:           fatalError("Unhandled Status: \(status)")
		}
	}
	
	/// Load a `CLuaFunction` onto the stack
	///
	/// - Parameter function: The function to load
	internal func load(function: @escaping CLuaFunction, valueCount: Count) {
		lua_pushcclosure(self.state, function, valueCount)
	}
}
