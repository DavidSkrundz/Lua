//
//  LuaError.swift
//  Lua
//

public enum LuaError: Error {
	case Syntax(String)
	case Runtime(String)
	case GarbageCollector(String)
	case MessageHandler(String)
	case TypeCreation(String)
	case IO(String)
	
	public var description: String {
		switch self {
			case let .Syntax(s):           return ".Syntax: \(s)"
			case let .Runtime(s):          return ".Runtime: \(s)"
			case let .GarbageCollector(s): return ".GarbageCollector: \(s)"
			case let .MessageHandler(s):   return ".MessageHandler: \(s)"
			case let .TypeCreation(s):     return ".TypeCreation: \(s)"
			case let .IO(s):               return ".IO: \(s)"
		}
	}
}
