//
//  LinuxMain.swift
//  Lua
//

@testable import LuaTests
import XCTest

XCTMain([
	testCase(LuaTests.allTests),
	testCase(StringTests.allTests),
])
