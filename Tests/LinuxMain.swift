//
//  LinuxMain.swift
//  Lua
//

@testable import LuaTests
import XCTest

XCTMain([
	testCase(LuaTests.allTests),
	testCase(NumberTests.allTests),
	testCase(StringTests.allTests),
])
